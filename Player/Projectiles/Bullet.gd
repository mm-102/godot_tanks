extends Projectile

#const ammo_type = Ammunition.TYPES.BULLET
#
func _init():
	s = GameSettings.Dynamic.Ammunition[0]

func _enter_tree():
	if not is_shot_sound_enabled:
		$Bullet_sound.autoplay = false
