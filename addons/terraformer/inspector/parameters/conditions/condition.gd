@icon("condition.svg")
class_name AdvancedModifierCondition
extends Resource

enum Mode {
 NORMAL,
 INVERT
}


@export var mode: Mode = Mode.NORMAL


func is_condition_met(grid: MapGrid, cell) -> bool:
 return false
