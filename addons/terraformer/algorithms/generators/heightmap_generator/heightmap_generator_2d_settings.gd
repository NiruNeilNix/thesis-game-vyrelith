class_name HeightmapGenerator2DSettings
extends GeneratorSettings2D



@export var tile: TileInfo
@export var noise: FastNoiseLite = FastNoiseLite.new()

@export var infinite := false :
 set(value):
  infinite = value
  notify_property_list_changed()
@export var world_length := 128



@export var height_offset := 128


@export var height_intensity := 20

@export var min_height := 0

@export var air_layer := true


func _validate_property(property: Dictionary) -> void:
 if property.name == "world_size" and infinite == true:
  property.usage = PROPERTY_USAGE_NONE
