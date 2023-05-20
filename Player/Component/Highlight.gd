extends Node2D

export var is_highlighting = false
export var _rect_size: Vector2
export var _position: Vector2
onready var color_rect_n = $ColorRect
onready var animation_player_n = $AnimationPlayer

func _ready():
	color_rect_n.rect_size = _rect_size
	color_rect_n.rect_position = _position

func highlight(_global_point = null):
	if _global_point != null:
		color_rect_n.rect_global_position = _global_point
	animation_player_n.play("highlight")
