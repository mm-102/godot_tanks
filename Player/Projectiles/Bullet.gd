extends Projectile

#const ammo_type = Ammunition.TYPES.BULLET
#
func _init():
	s = GameSettings.Dynamic.Ammunition[0]
