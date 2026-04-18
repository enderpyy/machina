extends Node2D

var repair_bay_number : int
@onready var label = $scale/Label
func _ready():
	label.text = name

func _focus(): # called by parent
	pass
func exit(): # lets parent know
	pass
