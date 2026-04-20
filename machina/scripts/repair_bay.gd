class_name RepairBay extends Node2D

@export var status_indicator :BayStatusIndicator
var repair_bay_number : int
var current_character = null

@onready var label = $bg_pixelator/scale/Label
func _ready():
	label.text = name
	#$bg_pixelator

func _focus(): # called by parent
	pass
func exit(): # lets parent know
	pass
