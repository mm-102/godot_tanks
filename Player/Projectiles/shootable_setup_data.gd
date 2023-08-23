extends Resource
class_name ShootableSetupData

var position
var rotation
var shooter



func setup_all(node: Node2D):
	node.position = position
	node.rotation = rotation
	node.shooter = shooter
