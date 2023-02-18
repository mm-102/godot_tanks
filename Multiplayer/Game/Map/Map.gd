extends Node

var ammo_box_tscn = preload("res://Objects/AmmoBox.tscn")

onready var tilemap_n = $"%TileMap"
onready var ammo_boxes_n = $"%AmmoBoxes"



func set_map_data(map_data):
	tilemap_n.scale = map_data.Scale
	set_mapset(map_data.MapSet)
	set_ammo_boxes(map_data.AB)
	tilemap_n.build_collision()

func set_mapset(tiles_pos):
	for tile_pos in tiles_pos:
		tilemap_n.set_cellv(tile_pos, 0)
		tilemap_n.update_bitmask_area(tile_pos)

func set_ammo_boxes(ab_many_data):
	for ab_data in ab_many_data:
		var ab_inst = ammo_box_tscn.instance()
		ab_inst.type = ab_data.Type
		ab_inst.set_position(ab_data.P)
		ammo_boxes_n.add_child(ab_inst)

func get_map_boundaries():
	var multiplier = tilemap_n.get_cell_size() * tilemap_n.scale
	var pos = tilemap_n.get_used_rect().position * multiplier
	var end = tilemap_n.get_used_rect().end * multiplier
	return {"Pos": pos, "End": end}
