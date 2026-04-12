extends Node

signal enemies_killed_updated(count: int)
signal all_enemies_defeated()

var enemies_to_kill: int = 4
var enemies_killed: int = 0

func register_kill():
	enemies_killed += 1
	emit_signal("enemies_killed_updated", enemies_killed)
	
	if enemies_killed >= enemies_to_kill:
		emit_signal("all_enemies_defeated")
		
func reset():
	enemies_killed = 0
