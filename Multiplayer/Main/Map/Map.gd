extends Node

onready var tilemap_n = $"%TileMap"



func set_mapset(tiles_pos):
	print(tiles_pos)
	for tile_pos in tiles_pos:
		tilemap_n.set_cellv(tile_pos, 0)
