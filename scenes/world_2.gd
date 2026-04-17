extends Node2D

@onready var overlay = get_node("ColorRect")

func _ready():
	GameManager.reset()
	GameManager.enemies_to_kill = 5
	GameManager.all_enemies_defeated.connect(_on_all_enemies_defeated)
	
	# Fade in on load
	await fade(1.0, 0.0)

func _on_all_enemies_defeated():
	await fade(0.0, 1.0, 2.0)
	get_tree().quit()

func fade(from_alpha: float, to_alpha: float, duration: float = 0.6) -> void:
	overlay.color.a = from_alpha
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(overlay, "color:a", to_alpha, duration)
	await tween.finished
