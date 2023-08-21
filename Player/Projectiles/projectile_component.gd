extends Node

export var speed = 100

func setup(data: ShootableSetupData):
	owner.shooter = data.shooter
	owner.position = data.position
	owner.set_linear_velocity(Vector2.UP.rotated(data.rotation) * speed)
