@tool
@icon("res://addons/terraformer/tokens/map_token.svg")
class_name TokenManager
extends Control



@export var tokens: Array[TokenData] = [] :
 set(value):
  tokens = value
  _ensure_unique_resources()
  _refresh_tokens()

@export var show_outlines: bool = true :
 set(value):
  show_outlines = value
  queue_redraw()

@export_range(1.0, 5.0, 0.5) var outline_width: float = 2.0 :
 set(value):
  outline_width = value
  queue_redraw()

@export_group("Label Settings")
@export_range(8, 32) var default_font_size: int = 12 :
 set(value):
  default_font_size = value
  queue_redraw()

@export var default_label_color: Color = Color.WHITE :
 set(value):
  default_label_color = value
  queue_redraw()


var _dragging_token: TokenData = null
var _drag_offset: Vector2 = Vector2.ZERO
var _hovered_token: TokenData = null

func _ready():
 mouse_filter = Control.MOUSE_FILTER_STOP
 _ensure_unique_resources()
 _refresh_tokens()

func _ensure_unique_resources():

 for i in range(tokens.size()):
  if tokens[i] and not tokens[i].resource_local_to_scene:
   tokens[i] = tokens[i].duplicate()

func _process(delta):

 if Engine.is_editor_hint():
  queue_redraw()

func _refresh_tokens():
 queue_redraw()

func _draw():
 for token in tokens:
  if token:
   _draw_token(token)

func _draw_token(token: TokenData):
 var color_with_alpha = Color(token.token_color, token.opacity)
 var rect = Rect2(token.position, token.size)

 match token.token_shape:
  TokenData.SHAPES.CIRCLE:
   _draw_circle_token(token, color_with_alpha)
  TokenData.SHAPES.SQUARE:
   _draw_square_token(token, color_with_alpha)
  TokenData.SHAPES.RECTANGLE:
   _draw_rectangle_token(token, color_with_alpha, rect)

 if token.token_label != "":
  _draw_token_label(token)

func _draw_circle_token(token: TokenData, color: Color):
 var radius = min(token.size.x, token.size.y) / 2.0
 var center = token.position + token.size / 2.0
 draw_circle(center, radius, color)
 if show_outlines:
  draw_arc(center, radius, 0, TAU, 32, token.token_color, outline_width)

func _draw_square_token(token: TokenData, color: Color):
 var sq_size = min(token.size.x, token.size.y)
 var square = Rect2(token.position, Vector2(sq_size, sq_size))
 draw_rect(square, color)
 if show_outlines:
  draw_rect(square, token.token_color, false, outline_width)

func _draw_rectangle_token(token: TokenData, color: Color, rect: Rect2):
 draw_rect(rect, color)
 if show_outlines:
  draw_rect(rect, token.token_color, false, outline_width)

func _draw_token_label(token: TokenData):
 var font = ThemeDB.fallback_font
 var label_size = font.get_string_size(
  token.token_label,
  HORIZONTAL_ALIGNMENT_CENTER,
  -1,
  default_font_size
 )

 var padding := 8
 if label_size.x > token.size.x - padding * 2 or label_size.y > token.size.y - padding * 2:
  return

 var label_pos = token.position + (token.size - label_size) / 2.0
 draw_string(font, label_pos + Vector2(1, 1), token.token_label, HORIZONTAL_ALIGNMENT_LEFT, -1, default_font_size, Color(0, 0, 0, 0.7))
 draw_string(font, label_pos, token.token_label, HORIZONTAL_ALIGNMENT_LEFT, -1, default_font_size, default_label_color)

func _gui_input(event):
 if not Engine.is_editor_hint():
  return

 if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
  if event.pressed:

   _dragging_token = _get_token_at_position(event.position)
   if _dragging_token:
    _drag_offset = event.position - _dragging_token.position
  else:
   _dragging_token = null

 elif event is InputEventMouseMotion:
  if _dragging_token:
   _dragging_token.position = event.position - _drag_offset
   queue_redraw()
  else:

   var old_hover = _hovered_token
   _hovered_token = _get_token_at_position(event.position)
   if _hovered_token != old_hover:
    _update_tooltip()

func _get_token_at_position(pos: Vector2) -> TokenData:

 for i in range(tokens.size() - 1, -1, -1):
  var token = tokens[i]
  if token and _is_point_in_token(pos, token):
   return token
 return null

func _is_point_in_token(point: Vector2, token: TokenData) -> bool:
 var local_point = point - token.position
 var half_size = token.size / 2.0

 match token.token_shape:
  TokenData.SHAPES.CIRCLE:
   var radius = min(token.size.x, token.size.y) / 2.0
   var center = token.size / 2.0
   return (local_point - center).length() <= radius
  TokenData.SHAPES.SQUARE:
   var sq_size = min(token.size.x, token.size.y)
   return local_point.x >= 0 and local_point.x <= sq_size and local_point.y >= 0 and local_point.y <= sq_size
  TokenData.SHAPES.RECTANGLE:
   return local_point.x >= 0 and local_point.x <= token.size.x and local_point.y >= 0 and local_point.y <= token.size.y

 return false

func _update_tooltip():
 if _hovered_token and _hovered_token.tooltip != "":
  tooltip_text = _hovered_token.tooltip
 else:
  tooltip_text = ""

func _notification(what):
 if what == NOTIFICATION_RESIZED:
  queue_redraw()


func add_token(token: TokenData):
 tokens.append(token)
 queue_redraw()

func remove_token(token: TokenData):
 tokens.erase(token)
 queue_redraw()

func clear_tokens():
 tokens.clear()
 queue_redraw()
