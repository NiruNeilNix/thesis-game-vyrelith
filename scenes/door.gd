extends Area2D

@export var next_scene: String = "res://scenes/world2.tscn"

var overlay: ColorRect

func _ready():
	visible = false
	monitoring = false
	
	# Create fade overlay
	var canvas_layer = CanvasLayer.new()
	overlay = ColorRect.new()
	overlay.color = Color(0, 0, 0, 0)
	overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	canvas_layer.add_child(overlay)
	add_child(canvas_layer)
	
	GameManager.all_enemies_defeated.connect(_on_all_enemies_defeated)
	body_entered.connect(_on_body_entered)

func _on_all_enemies_defeated():
	visible = true
	monitoring = true

func _on_body_entered(body):
	if body.is_in_group("player"):
		await fade(0.0, 1.0)
		GameManager.reset()
		get_tree().call_deferred("change_scene_to_file", next_scene)

func fade(from_alpha: float, to_alpha: float, duration: float = 0.6) -> void:
	overlay.color.a = from_alpha
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(overlay, "color:a", to_alpha, duration)
	await tween.finished
