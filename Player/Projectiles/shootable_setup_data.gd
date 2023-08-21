extends Node
class_name ShootableSetupData

var position
var rotation
var shooter

func setup_all(node: Node2D):
	node.position = position
	node.rotation = rotation
	node.shooter = shooter

func setup_rigid_body(node: RigidBody2D):
	node.position = position
	node.set_linear_velocity(Vector2.UP.rotated(rotation) * node.speed)
	node.shooter = shooter
	
