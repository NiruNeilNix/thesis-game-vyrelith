@tool
class_name Modifier
extends Resource

enum FilterType {
 NONE,
 BLACKLIST,
 WHITELIST,
 ONLY_EMPTY_CELLS
}

@export_group("")
@export var enabled: bool = true
@export var affected_layers: Array[int] = [0]
@export_group("Filters")
@export var strict_filters: bool = true
@export var filters: Array[Filter] = []

func apply(grid: MapGrid, generator: TerraGenerator) -> void:
 pass

func _passes_filter(grid: MapGrid, cell) -> bool:
 if filters.is_empty():
  return strict_filters
 for flt in filters:
  var did_pass: bool = flt._passes_filter(grid, cell)
  if did_pass and not strict_filters:
   return true
  if not did_pass and strict_filters:
   return false
 return strict_filters

func _validate_property(property: Dictionary) -> void:
 pass
