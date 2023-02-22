extends TileMap

const ammo_box_tscn = preload("res://Objects/AmmoBox.tscn")

onready var ammo_types_size = Ammunition.TYPES.size()
onready var ammo_boxes_n = $"%AmmoBoxes"

func _ready():
	var cells = get_used_cells()
	for i in cells.size():
		var box = ammo_box_tscn.instance()
		box.type = 1 + i % (ammo_types_size - 1)
		box.position = (cells[i] + Vector2(0.5,0.5)) * cell_size * scale
		ammo_boxes_n.add_child(box)
	
	queue_free()
