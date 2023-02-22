extends Projectile


var FRAG_COUNT
var FRAG_SPEED
var FRAG_SCALE
var FRAG_LIFETIME_MULTIPLIER
var FRAG_TYPE

func set_params():
	SPEED = $"/root/Master/Settings".SETTINGS.FRAG_BOMB_SPEED
	FRAG_COUNT = $"/root/Master/Settings".SETTINGS.FRAG_COUNT
	FRAG_SPEED = $"/root/Master/Settings".SETTINGS.FRAG_SPEED
	FRAG_SCALE = $"/root/Master/Settings".SETTINGS.FRAG_SCALE
	FRAG_LIFETIME_MULTIPLIER = $"/root/Master/Settings".SETTINGS.FRAG_LIFETIME_MULTIPLIER
	FRAG_TYPE = $"/root/Master/Settings".SETTINGS.FRAG_TYPE

func _ready():
	set_params()


func spawn_frag(rotation):
	var frag_inst = load("res://Global/Ammunition.gd").get_tscn(FRAG_TYPE).instance()

	var frag_timer : Timer = frag_inst.get_node("LifeTime")
	frag_timer.wait_time *= FRAG_LIFETIME_MULTIPLIER
	
	var frag_sprite : Sprite = frag_inst.get_node("Sprite")
	frag_sprite.set_scale(frag_sprite.scale * FRAG_SCALE)
	
	var frag_col_shape : CollisionShape2D = frag_inst.get_node("CollisionShape2D")
	frag_col_shape.set_scale(frag_col_shape.scale * FRAG_SCALE)
	
	var velocity = Vector2.UP.rotated(rotation)
	frag_inst.position = position + 1 * velocity # separate frags from each other
	frag_inst.set_linear_velocity(velocity * FRAG_SPEED)
	get_node(Dir.PROJECTILES).add_child(frag_inst)
	
func explode():
	for n in range(FRAG_COUNT):
		var rotation = 2 * PI * n / FRAG_COUNT
		call_deferred("spawn_frag", rotation)

	.die()	#call super die() function

func die():
	explode()
