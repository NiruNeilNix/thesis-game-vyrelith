@icon("../generator_settings.svg")
class_name GeneratorSettings2D
extends Resource

@export var modifiers: Array[Modifier2D]

func _init() -> void:
 if resource_name == "":
  resource_name = "Settings"
