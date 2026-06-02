@tool
@icon("heightmap_painter.svg")
class_name HeightmapPainter
extends ChunkAwareModifier2D






@export var use_generator_noise: bool = true:
 set(value):
  use_generator_noise = value
  notify_property_list_changed()
@export var ignore_empty_cells: bool = true
@export var noise: FastNoiseLite = FastNoiseLite.new()
@export var tile: TileInfo




@export var height_offset := 128


@export var height_intensity := 20


func _apply_area(area: Rect2i, grid: MapGrid, _generator: TerraGenerator) -> void:
 for x in range(area.position.x, area.end.x + 1):
  for y in range(area.position.y, area.end.y + 1):
   var cell := Vector2i(x, y)
   if not grid.has_cell(cell, tile.layer) and ignore_empty_cells:
    continue

   var height = floor(noise.get_noise_1d(cell.x) * height_intensity + height_offset)
   if cell.y >= -height:
    if not _passes_filter(grid, cell):
     continue

    grid.set_value(cell, tile)


func _validate_property(property: Dictionary) -> void:
 super(property)
 if property.name == "affected_layers":
  property.usage = PROPERTY_USAGE_NONE
