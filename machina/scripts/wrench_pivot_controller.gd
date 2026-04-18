extends RigidBody2D

var current_joint := "pin" #spring or pin

@onready
var pin = $"Pin Pivot"
@export
var wrench : RigidBody2D

func swap_joint():
	if current_joint == "pin":
		pin.softness = 4
		current_joint = "spring"
	elif current_joint == "spring":
		pin.softness = 16
		current_joint = "pin"
		
