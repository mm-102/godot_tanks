extends Sprite

const margin = 20

var target_player = null
var player = null
var texture_size = max(texture.get_size().x, texture.get_size().y) * scale.x

func _process(delta):
	if target_player == null or !is_instance_valid(target_player):
		queue_free()
		return
	visible = !target_player.visible_to_local_player
	if !visible:
		return
	
	var to_target = (target_player.global_position - player.global_position)
	var disance = to_target.length()
	var direction = to_target.normalized()
	var angle = direction.angle()
	var viewport_size = get_viewport().size
	
	if direction.y > 0:
		$Label.rect_rotation = 180
	
	else:
		$Label.rect_rotation = 0
	$Label.text = str(round(disance))
	
	rotation = angle + PI/2
	
	if cos(angle) == 0:
		position = direction * ((viewport_size.y - texture_size) * 0.5 - margin)
		return
	
	if sin(angle) == 0:
		position = direction * ((viewport_size.x - texture_size) * 0.5 - margin)
		return
	
	var factor = min(\
	abs(viewport_size.x / cos(angle)),\
	abs(viewport_size.y / sin(angle))\
	)
	position = direction * ((factor - texture_size) * 0.5 - margin)