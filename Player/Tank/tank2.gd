extends KinematicBody2D
class_name Tank

const tank_wreck = preload("res://Player/Tank/TankWreck.tscn")

export var display_name: String = "abc" setget set_display_name
func set_display_name(new):
	display_name = new
	$Nick.text = display_name
export var color: Color = Color.white setget set_color
func set_color(new):
	color = new
	self.modulate = color

var movement_speed = 100
var rotation_speed = 2

var is_multiplayer = false

onready var rotor = $Rotor
onready var collision = $Collision



func _ready():
	set_display_name("")


func _physics_process(delta):
	movement(delta)

func movement(delta):
	var velocity: Vector2 = Vector2.ZERO
	var y_direction = Input.get_action_strength("p_backward") - Input.get_action_strength("p_forward")
	var x_direction = Input.get_action_strength("p_right") - Input.get_action_strength("p_left")
	if y_direction > 0:
		x_direction = -x_direction
	rotor.rotation += x_direction * rotation_speed * delta
	collision.rotation = rotor.rotation
	velocity = Vector2(0, y_direction * movement_speed).rotated(rotor.rotation)
	
	var _x = move_and_slide(velocity)

func die():
	queue_free()
	
	if not is_multiplayer:
		spawn_wreck()


func spawn_wreck():
	var wreck = tank_wreck.instance()
	var wreck_data = WreckSetupData.new()
	wreck_data.position = self.global_position
	wreck_data.rotation = rotor.global_rotation
	wreck_data.color = self.modulate
	wreck.setup(wreck_data)
	get_tree().get_root().call_deferred("add_child", wreck)
