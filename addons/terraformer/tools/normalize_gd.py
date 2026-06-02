#!/usr/bin/env python3
"""
Normalize GDScript files: remove comments and make indentation use a single space per indent level.
Backs up original files with a .bak extension.
"""
import io
import os
import re
import sys

# Patterns
STRING_RE = re.compile(r"('([^'\\]|\\.)*'|\"([^\\\"]|\\.)*\")")
TRIPLE_QUOTE_RE = re.compile(r"('{3}|\"{3})")


def remove_comments_and_normalize(code: str) -> str:
    # We'll parse line by line but keep track of whether we're inside a triple-quoted string
    out_lines = []
    in_triple = False
    triple_delim = None
    for line in code.splitlines():
        i = 0
        n = len(line)
        if in_triple:
            # check for end triple
            idx = line.find(triple_delim)
            if idx != -1:
                # keep upto end of triple (string content) and then continue
                before = line[:idx + 3]
                out_lines.append(before)
                rest = line[idx + 3:]
                in_triple = False
                triple_delim = None
                # process rest of line normally
                line = rest
                i = 0
                n = len(line)
            else:
                # whole line is inside triple-quoted string; keep as-is
                out_lines.append(line)
                continue

        # remove single-line comments but preserve those inside strings
        new_line = ''
        while i < n:
            m = STRING_RE.search(line, i)
            tq = TRIPLE_QUOTE_RE.search(line, i)
            # choose nearest
            nearest = None
            if m and tq:
                nearest = m if m.start() < tq.start() else tq
            elif m:
                nearest = m
            elif tq:
                nearest = tq

            if nearest is None:
                # no string/quote ahead: strip out any # and following
                hash_idx = line.find('#', i)
                if hash_idx != -1:
                    new_line += line[i:hash_idx]
                else:
                    new_line += line[i:]
                break

            if nearest.re is TRIPLE_QUOTE_RE:
                # triple quote found
                start = nearest.start()
                new_line += line[i:start]
                delim = nearest.group(1)
                # check if this triple closes on same line
                end_idx = line.find(delim, start + 3)
                if end_idx != -1:
                    # include whole triple-quoted string
                    new_line += line[start:end_idx + 3]
                    i = end_idx + 3
                    continue
                else:
                    # starts triple and continues; include rest and mark in_triple
                    new_line += line[start:]
                    in_triple = True
                    triple_delim = delim
                    break

            # normal string found
            start, end = nearest.start(), nearest.end()
            new_line += line[i:start]
            new_line += line[start:end]
            i = end

        # Now new_line has code with comments removed (outside strings/triple strings preserved)
        # Normalize indentation: replace leading tabs or multiple spaces with one space per indent level
        # We'll detect indent level by counting leading tabs and groups of 4 spaces
        leading = len(new_line) - len(new_line.lstrip('\t '))
        if leading > 0:
            raw_indent = new_line[:leading]
            # count tabs as indent level 1 each, count 4 spaces as one indent
            tabs = raw_indent.count('\t')
            spaces = raw_indent.count(' ')
            # assume indent unit = 4 spaces if spaces present
            indent_levels = tabs + (spaces // 4)
            # fallback: if spaces not multiple of 4, treat each 1 as level
            if spaces and spaces % 4 != 0:
                indent_levels = tabs + spaces
            new_indent = ' ' * indent_levels
            new_line = new_indent + new_line.lstrip('\t ')

        # strip trailing whitespace
        new_line = new_line.rstrip()
        out_lines.append(new_line)

    return '\n'.join(out_lines) + ('\n' if code.endswith('\n') else '')


def process_file(path: str, inplace=True):
    with open(path, 'r', encoding='utf-8') as f:
        orig = f.read()
    new = remove_comments_and_normalize(orig)
    if new == orig:
        return False
    bak = path + '.bak'
    if not os.path.exists(bak):
        with open(bak, 'w', encoding='utf-8') as f:
            f.write(orig)
    with open(path, 'w', encoding='utf-8') as f:
        f.write(new)
    return True


if __name__ == '__main__':
    root = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
    changed = []
    for dirpath, dirnames, filenames in os.walk(root):
        # skip .import files and .git
        for fn in filenames:
            if fn.endswith('.gd'):
                p = os.path.join(dirpath, fn)
                try:
                    if process_file(p):
                        changed.append(p)
                except Exception as e:
                    print('Error processing', p, e, file=sys.stderr)
    print('Changed files:')
    for c in changed:
        print(c)
