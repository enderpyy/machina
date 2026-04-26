class_name Wire extends Node2D

signal connected
var is_connected := false

@onready var wire = $Line
@onready var end = $End
@onready var middle = $Middle
@onready var start = $Start
@onready var FrayedWire = $FrayedWire
func _process(delta: float) -> void:
	if !end.freeze:
		update_wire()

func update_wire():
	wire.clear_points()
	wire.add_point(start.position)
	wire.add_point(middle.position)
	wire.add_point(end.position)
	FrayedWire.position = end.position


func _on_end_connected(b : bool) -> void:
	#print("connected " + str(b))
	is_connected = b
	connected.emit(b)
	
