extends Control

@onready var overlay = get_node("CanvasLayer/ColorRect")

func _ready():
	overlay.color.a = 1.0

func _on_retry_button_pressed():
	GameManager.reset()
	get_tree().call_deferred("change_scene_to_file", "res://scenes/world.tscn")

func fade(from_alpha: float, to_alpha: float, duration: float = 0.6) -> void:
	overlay.color.a = from_alpha
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(overlay, "color:a", to_alpha, duration)
	await tween.finished
