@tool
class_name OffsetCondition2D
extends AdvancedModifierCondition2D



enum Offsets {
 BELOW,
 ABOVE,
 LEFT,
 RIGHT,
 CUSTOM
 }

@export var offset: Offsets :
 set(value):
  offset = value
  notify_property_list_changed()
@export var custom_offset: Vector2i

@export var ids: Array[StringName]

@export var layers: Array[int] = [0]


func is_condition_met(grid: MapGrid, cell: Vector2i) -> bool:
 var _offset: Vector2i = custom_offset
 match offset:
  Offsets.BELOW:
   _offset = Vector2i.DOWN
  Offsets.ABOVE:
   _offset = Vector2i.UP
  Offsets.LEFT:
   _offset = Vector2i.LEFT
  Offsets.RIGHT:
   _offset = Vector2i.RIGHT

 for layer in layers:
  var value = grid.get_value(cell + _offset, layer)
  if value is TileInfo and value.id in ids:
   return true
 return false


func _validate_property(property: Dictionary) -> void:
 if property.name == "custom_offset" and offset != Offsets.CUSTOM:
  property.usage = PROPERTY_USAGE_NONE
