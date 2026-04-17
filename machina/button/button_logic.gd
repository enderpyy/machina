extends Node2D
'''
Logic for button
NO transforms on polygon allowed besides Position

uses both a SIGNAL and a PARENT FUNCTION CALL
'''

@onready var poly := owner
var mouse_down := false

signal pressed

func _process(_d):
	var points: PackedVector2Array = poly.polygon
	var trans: Transform2D = poly.global_transform
	prints(trans.get_origin(), trans.get_rotation(), trans.get_scale())
	print("before: ", points.slice(0, 3))
	for p in points:
		p = trans.basis_xform(p)
	print("after: ", points.slice(0, 3))
	#if Geometry2D.is_point_in_polygon(globals.mpos - poly.global_transform.origin, poly.polygon):
	if Geometry2D.is_point_in_polygon(globals.mpos, points):
		if Input.is_action_just_pressed("left_click"):
			mouse_down = true
			call_parent()
		if Input.is_action_just_released("left_click"):
			mouse_down = false
			call_parent()

func call_parent():
	# SIGNAL
	owner.pressed.emit(mouse_down)
	# PARENT FUNCTION CALL
	var grandma = owner.get_parent()
	if owner.has_method("button_pressed"): grandma.button_pressed(self)
	
