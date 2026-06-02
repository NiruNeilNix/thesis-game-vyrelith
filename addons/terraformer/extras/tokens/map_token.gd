@tool
@icon("res://addons/terraformer/tokens/map_token.svg")
class_name MapToken
extends Control

enum TOKENS {
 PLAYER,
 ENEMY,
 ITEM_PICKUP,
 DIALOGUE,
 CUTSCENE
}

enum SHAPES {
 CIRCLE,
 RECTANGLE
}

var TOKEN_DEFAULTS := {
 TOKENS.PLAYER: {
  "color": Color.GREEN,
  "shape": SHAPES.CIRCLE,
  "label": "Player"
 },
 TOKENS.ENEMY: {
  "color": Color.RED,
  "shape": SHAPES.RECTANGLE,
  "label": "Enemy"
 },
 TOKENS.ITEM_PICKUP: {
  "color": Color.YELLOW,
  "shape": SHAPES.RECTANGLE,
  "label": "Item"
 },
 TOKENS.DIALOGUE: {
  "color": Color.CORNFLOWER_BLUE,
  "shape": SHAPES.RECTANGLE,
  "label": "Dialogue"
 },
 TOKENS.CUTSCENE: {
  "color": Color.PURPLE,
  "shape": SHAPES.RECTANGLE,
  "label": "Cutscene"
 }
}

@export_group("Token Settings")
@export var token_type: TOKENS = TOKENS.PLAYER:
 set(value):
  token_type = value


  var d = TOKEN_DEFAULTS[value]
  token_color = d["color"]
  token_shape = d["shape"]
  if token_label == "":
   token_label = d["label"]

  queue_redraw()

@export var token_shape: SHAPES = SHAPES.CIRCLE:
 set(value):
  token_shape = value
  queue_redraw()

@export_color_no_alpha var token_color: Color = Color.DODGER_BLUE:
 set(value):
  token_color = value
  queue_redraw()

@export_range(0.3, 1.0, 0.05) var opacity: float = 0.7:
 set(value):
  opacity = value
  queue_redraw()

@export_group("Label")
@export var token_label: String = "":
 set(value):
  token_label = value
  queue_redraw()

@export_range(8, 32) var label_font_size: int = 12:
 set(value):
  label_font_size = value
  queue_redraw()

@export var label_color: Color = Color.WHITE:
 set(value):
  label_color = value
  queue_redraw()

@export_group("Tooltip")
@export_multiline var token_tooltip: String = "":
 set(value):
  token_tooltip = value
  tooltip_text = value

func _get_tooltip(at_position: Vector2) -> String:

 return "Type: %s\nLabel: %s\nColor: %s\nPosition: (%d, %d)" % [
  TOKENS.keys()[token_type],
  token_label,
  token_color.to_html(),
  int(global_position.x),
  int(global_position.y)
 ]

@export_group("Size")
@export var use_fixed_size: bool = false:
 set(value):
  use_fixed_size = value
  custom_minimum_size = token_size if use_fixed_size else Vector2.ZERO
  queue_redraw()

@export var token_size: Vector2 = Vector2(64, 64):
 set(value):
  token_size = value
  if use_fixed_size:
   custom_minimum_size = token_size
   size = token_size
  queue_redraw()


@export_group("Outline")
@export var show_outline: bool = true:
 set(value):
  show_outline = value
  queue_redraw()

@export_range(1.0, 5.0, 0.5) var outline_width: float = 2.0:
 set(value):
  outline_width = value
  queue_redraw()


var _dragging := false


func _ready():
 mouse_filter = Control.MOUSE_FILTER_STOP

 if use_fixed_size:
  custom_minimum_size = token_size


 if token_tooltip != "":
  tooltip_text = token_tooltip

 if Engine.is_editor_hint():
  var manager = get_tree().get_first_node_in_group("token_manager")
  if manager:
   manager.register_token(self)

func _notification(what):
 if what == NOTIFICATION_RESIZED:
  queue_redraw()


func _draw():
 var color_with_alpha = Color(token_color, opacity)
 var rect = Rect2(Vector2.ZERO, size)

 match token_shape:
  SHAPES.CIRCLE:
   _draw_circle_token(color_with_alpha)
  SHAPES.RECTANGLE:
   _draw_rectangle_token(color_with_alpha, rect)

 if token_label != "":
  _draw_label()

func _draw_circle_token(color: Color):
 var radius = min(size.x, size.y) / 2.0
 var center = size / 2.0
 draw_circle(center, radius, color)
 if show_outline:
  draw_arc(center, radius, 0, TAU, 32, token_color, outline_width)

func _draw_square_token(color: Color):
 var sq_size = min(size.x, size.y)
 var square = Rect2(Vector2.ZERO, Vector2(sq_size, sq_size))
 draw_rect(square, color)
 if show_outline:
  draw_rect(square, token_color, false, outline_width)

func _draw_rectangle_token(color: Color, rect: Rect2):
 draw_rect(rect, color)
 if show_outline:
  draw_rect(rect, token_color, false, outline_width)

func _draw_label():
 var font = ThemeDB.fallback_font
 var label_size = font.get_string_size(
  token_label,
  HORIZONTAL_ALIGNMENT_CENTER,
  -1,
  label_font_size
 )

 var padding := 8
 if label_size.x > size.x - padding * 2 or label_size.y > size.y - padding * 2:
  return

 var pos = (size - label_size) / 2.0
 draw_string(font, pos + Vector2(1,1), token_label, HORIZONTAL_ALIGNMENT_LEFT, -1, label_font_size, Color(0,0,0,0.7))
 draw_string(font, pos, token_label, HORIZONTAL_ALIGNMENT_LEFT, -1, label_font_size, label_color)


func _gui_input(event):
 if not Engine.is_editor_hint():
  return

 if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
  _dragging = event.pressed
 elif event is InputEventMouseMotion and _dragging:
  global_position += event.relative
