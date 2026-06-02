@tool
class_name TokenData
extends Resource



enum TOKENS {
 PLAYER,
 ENEMY,
 ITEM_PICKUP,
 DIALOGUE,
 CUTSCENE
}

enum SHAPES {
 CIRCLE,
 SQUARE,
 RECTANGLE
}

@export var token_type: TOKENS = TOKENS.PLAYER
@export var token_shape: SHAPES = SHAPES.CIRCLE
@export_color_no_alpha var token_color: Color = Color.DODGER_BLUE
@export var token_label: String = ""
@export var position: Vector2 = Vector2.ZERO
@export var size: Vector2 = Vector2(64, 64)
@export_range(0.3, 1.0, 0.05) var opacity: float = 0.7
@export_multiline var tooltip: String = ""

func _init(
 p_type: TOKENS = TOKENS.PLAYER,
 p_shape: SHAPES = SHAPES.CIRCLE,
 p_color: Color = Color.DODGER_BLUE,
 p_label: String = "",
 p_position: Vector2 = Vector2.ZERO
):
 token_type = p_type
 token_shape = p_shape
 token_color = p_color
 token_label = p_label
 position = p_position
