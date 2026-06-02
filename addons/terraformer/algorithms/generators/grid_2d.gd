class_name MapGrid2D
extends MapGrid


const SURROUNDING := [
 Vector2i.RIGHT, Vector2i.LEFT,
 Vector2i.UP, Vector2i.DOWN,
 Vector2i(1, 1), Vector2i(1, -1),
 Vector2i(-1, -1), Vector2i(-1, 1)
]




func set_value(pos: Vector2i, value: Variant, layer: int = -1) -> void:
 super(pos, value, layer)



func set_valuexy(x: int, y: int, value: Variant, layer: int = -1) -> void:
 set_value(Vector2i(x, y), value, layer)




func get_value(pos: Vector2i, layer: int) -> Variant:
 return super(pos, layer)




func get_valuexy(x: int, y: int, layer: int) -> Variant:
 return get_value(Vector2i(x, y), layer)



func get_area() -> Rect2i:
 var bounds: Rect2i
 for layer_index in range(get_layer_count()):
  var layer_cells = get_cells(layer_index)
  if layer_cells.is_empty():
   continue

  if bounds == Rect2i():
   bounds = Rect2i(layer_cells.front(), Vector2i.ZERO)

  for cell in layer_cells:
   bounds = bounds.expand(cell)
 return bounds



func has_cell(pos: Vector2i, layer: int) -> bool:
 if not has_layer(layer):
  return false
 return super(pos, layer)



func has_cellxy(x: int, y: int, layer: int) -> bool:
 return has_cell(Vector2i(x, y), layer)



func erase(pos: Vector2i, layer: int) -> void:
 super(pos, layer)



func erasexy(x: int, y: int, layer: int) -> void:
 erase(Vector2i(x, y), layer)



func get_amount_of_empty_neighbors(pos: Vector2i, layer: int) -> int:
 var empty_count: int = 0

 for neighbor_offset in SURROUNDING:
  if get_value(pos + neighbor_offset, layer) == null:
   empty_count += 1

 return empty_count




func get_surrounding_cells(pos: Vector2i, layer: int, ignore_empty: bool = false) -> Array[Vector2i]:
 var neighbor_positions: Array[Vector2i]

 for neighbor_offset in SURROUNDING:
  if ignore_empty and not has_cell(pos + neighbor_offset, layer):
   continue
  neighbor_positions.append(pos + neighbor_offset)

 return neighbor_positions
