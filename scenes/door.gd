# door.gd
extends Area2D

@export var next_scene: String = "res://scenes/world2.tscn"

func _ready():
	# Start hidden
	visible = false
	monitoring = false
	
	GameManager.all_enemies_defeated.connect(_on_all_enemies_defeated)
	body_entered.connect(_on_body_entered)
	print("Door Ready")


func _on_all_enemies_defeated():
	print("door signal received")
	visible = true
	monitoring = true

func _on_body_entered(body):
	print("Entering Door")
	if body.is_in_group("player"):
		GameManager.reset()
		get_tree().call_deferred("change_scene_to_file", next_scene)  
