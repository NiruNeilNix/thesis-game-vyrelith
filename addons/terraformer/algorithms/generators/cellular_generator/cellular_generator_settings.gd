@tool
class_name CellularGeneratorSettings
extends GeneratorSettings2D



@export var tile: TileInfo

@export var world_size: Vector2i = Vector2i(64, 64)


@export_range(0.0, 1.0) var noise_density := 0.5


@export var smooth_iterations := 6
@export_group("Conditions")



@export_range(0, 8) var max_floor_empty_neighbors := 4



@export_range(0, 8) var min_empty_neighbors := 3
