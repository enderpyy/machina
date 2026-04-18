extends Node2D

var repair_bay_number : int
@onready var label = $bg_pixelator/scale/Label
func _ready():
	label.text = name
	$bg_pixelator

func _focus(): # called by parent
	pass
func exit(): # lets parent know
	pass
