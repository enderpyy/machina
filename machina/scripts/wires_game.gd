extends Node2D

var wires : Array[Wire]
var connectors : Array[WireConnector]

@export var colors: Array[Color]

signal game_finished

func _ready() -> void:
	for child in get_children():
		if child is Wire:
			wires.append(child)
			child.connected.connect(wire_connected)
		elif child is WireConnector:
			connectors.append(child)
	
	assert(wires.size() == connectors.size(), "Invalid wire - connector ratio")
	assert(wires.size() == colors.size(), "Invalid amount of colors for wires")
	
	var temp_wires = wires.duplicate()
	var temp_connectors = connectors.duplicate()
	for i in range(wires.size()):
		temp_wires.pop_at(randi() % temp_wires.size()).modulate = colors[i]
		temp_connectors.pop_at(randi() % temp_connectors.size()).modulate = colors[i]

func wire_connected(b : bool):
	if b:
		print('\nchecking...')
		for w in wires:
			print('wire connected? ', w.is_connected)
			if !w.is_connected:
				return
		game_finished.emit()


func _on_wire_connected(b) -> void:
	wire_connected(b)


func _on_wire_2_connected(b) -> void:
	wire_connected(b)


func _on_wire_3_connected(b) -> void:
	wire_connected(b)


func _on_wire_4_connected(b) -> void:
	wire_connected(b)
