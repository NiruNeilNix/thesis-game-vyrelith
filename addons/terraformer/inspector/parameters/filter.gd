@tool
class_name Filter
extends Resource

enum FilterType {
 NONE,
 BLACKLIST,
 WHITELIST,
 ONLY_EMPTY_CELLS
}

@export var filter_type: FilterType = FilterType.NONE:
 set(value):
  filter_type = value
  notify_property_list_changed()

@export var filter_ids: Array[String] = []
@export var filter_layers: Array[int] = []

func _passes_filter(grid: MapGrid, cell) -> bool:
 if filter_type == FilterType.NONE:
  return true

 if filter_type == FilterType.ONLY_EMPTY_CELLS:
  for layer in grid.get_layer_count():
   if grid.get_value(cell, layer) != null:
    return false
  return true

 var layers: Array = filter_layers
 if layers.is_empty():
  layers = grid.get_grid().keys()

 for layer in layers:
  var value = grid.get_value(cell, layer)
  if value is TileInfo and value.id in filter_ids:
   return filter_type == FilterType.WHITELIST

 return filter_type == FilterType.BLACKLIST

func _validate_property(property: Dictionary) -> void:
 if (property.name == "filter_ids" or property.name == "filter_layers") and filter_type == FilterType.NONE:
  property.usage = PROPERTY_USAGE_NONE
 elif property.name == "filter_ids" and filter_type == FilterType.ONLY_EMPTY_CELLS:
  property.usage = PROPERTY_USAGE_NONE
