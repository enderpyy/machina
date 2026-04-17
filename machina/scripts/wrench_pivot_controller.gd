extends RigidBody2D

var current_joint := "pin" #spring or pin

@onready
var pin = $"Pin Pivot"
@onready
var spring = $"Spring Pivot"
@export
var placeholder : RigidBody2D
@export
var wrench : RigidBody2D

func swap_joint():
	if current_joint == "pin":
		pin.node_a = placeholder.get_path()
		spring.node_a = wrench.get_path()
		current_joint = "spring"
	elif current_joint == "spring":
		wrench.position = position
		spring.node_a = placeholder.get_path()
		pin.node_a = wrench.get_path()
		current_joint = "pin"
		
