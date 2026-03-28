extends Control

func _on_button_pressed() -> void:
	await fade(0.0, 1.0)
	get_tree().change_scene_to_file("res://scenes/world.tscn")

func _on_exit_button_pressed() -> void:
	await fade(0.0, 1.0)
	get_tree().quit()

func fade(from_alpha: float, to_alpha: float, duration: float = 0.6) -> void:
	var overlay = $ColorRect2
	overlay.color.a = from_alpha         

	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(overlay, "color:a", to_alpha, duration)  
	await tween.finished
