class_name RepairBay extends Node2D

@export var status_indicator :BayStatusIndicator
var repair_bay_number : int
var current_character = null
var charger = preload("res://scenes/charger.tscn")
var charger_pos = Vector2(1492, 821)


@onready var label = $bg_pixelator/scale/Label
func _ready():
	$Label.text = name
	var parent : FNAF_base
	await get_tree().process_frame
	parent = get_parent()
	await parent.anim.animation_finished
	var c = charger.instantiate()
	add_child(c)
	c.position = charger_pos
	#$bg_pixelator

func _focus(): # called by parent
	pass
func exit(): # lets parent know
	pass
