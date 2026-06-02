extends Node2D

func _ready():
	GameManager.reset()
	GameManager.enemies_to_kill = 5
	#GameManager.enemies_to_kill = get_tree().get_nodes_in_group("enemies").size()
	#print("Enemies to kill: ", GameManager.enemies_to_kill)
	print("Enemies to kill: ", GameManager.enemies_to_kill)
	print("Nodes in group: ", get_tree().get_nodes_in_group("enemies"))
