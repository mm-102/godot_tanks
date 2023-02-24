extends TileMap

const ammo_box_tscn = preload("res://Objects/AmmoBox.tscn")

onready var ammo_types_size = Ammunition.TYPES.size()
onready var ammo_boxes_n = $"%AmmoBoxes"

func _ready():
	var cells = get_used_cells()
	var type = 0
	for i in cells.size():
		var box = ammo_box_tscn.instance()
		if type == $"/root/Master/Settings".SETTINGS.PLAYER_BASE_AMMO_TYPE:
			type = (type + 1) % ammo_types_size
		box.type = type
		box.position = (cells[i] + Vector2(0.5,0.5)) * cell_size * scale
		ammo_boxes_n.add_child(box)
		type = (type + 1) % ammo_types_size
	
	queue_free()
