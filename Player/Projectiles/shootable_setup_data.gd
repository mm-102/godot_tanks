extends Node
class_name ShootableSetupData

var position
var rotation
var shooter

var frag_speed_multiplier
var frag_lifetime_multiplier
var frag_scale_multiplier



func setup_all(node: Node2D):
	node.position = position
	node.rotation = rotation
	node.shooter = shooter
