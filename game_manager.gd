extends Node

signal enemies_killed_updated(count: int)
signal all_enemies_defeated()

var enemies_to_kill: int = 5
var enemies_killed: int = 0

func register_kill():
	enemies_killed += 1
	print("Kills: ", enemies_killed, " / ", enemies_to_kill) 
	emit_signal("enemies_killed_updated", enemies_killed)
	
	if enemies_killed >= enemies_to_kill:
		print("Emitting all_enemies_defeated!")  
		emit_signal("all_enemies_defeated")
		
func reset():
	enemies_killed = 0

func game_over():
	# Create fade overlay
	var canvas_layer = CanvasLayer.new()
	var overlay = ColorRect.new()
	overlay.color = Color(0, 0, 0, 0)
	overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	canvas_layer.add_child(overlay)
	get_tree().current_scene.add_child(canvas_layer)
	
	# Slow dramatic fade
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(overlay, "color:a", 1.0, 2.0)
	await tween.finished
	get_tree().call_deferred("change_scene_to_file", "res://scenes/ui/game_over.tscn")
