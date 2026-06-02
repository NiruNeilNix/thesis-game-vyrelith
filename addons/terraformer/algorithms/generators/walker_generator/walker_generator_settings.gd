@tool
class_name WalkerGeneratorSettings
extends GeneratorSettings2D


enum FullnessCheck { TILE_AMOUNT, PERCENTAGE }



@export var tile: TileInfo

@export var fullness_check: FullnessCheck:
 set(value):
  fullness_check = value
  if fullness_check == FullnessCheck.PERCENTAGE:
   constrain_world_size = true
  notify_property_list_changed()

@export var max_tiles := 150

@export var fullness_percentage := 0.2

@export var constrain_world_size: bool = false:
 set(value):
  if fullness_check == FullnessCheck.PERCENTAGE and value == false:
   return
  constrain_world_size = value
  notify_property_list_changed()
@export var world_size := Vector2i(30, 30)


@export_group("Walkers")



@export var max_walkers = 5


@export var new_dir_chance = 0.5

@export var new_walker_chance = 0.05


@export var destroy_walker_chance = 0.05




@export var room_chances = {Vector2i(2, 2): 0.5, Vector2i(3, 3): 0.1}


func _validate_property(property: Dictionary) -> void:
 match fullness_check:
  FullnessCheck.TILE_AMOUNT:
   if property.name == "fullness_percentage":
    property.usage = PROPERTY_USAGE_NONE
  FullnessCheck.PERCENTAGE:
   if property.name == "max_tiles":
    property.usage = PROPERTY_USAGE_NONE
 if not constrain_world_size and property.name == "world_size":
  property.usage = PROPERTY_USAGE_NONE
