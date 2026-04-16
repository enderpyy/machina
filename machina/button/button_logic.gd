extends Node2D
'''
Logic for button
NO transforms on polygon allowed besides Position

calls button_pressed in parent and attaches self
'''

@onready var poly := owner
var mouse_down:=false

signal pressed

func _process(_d):
	#var points: PackedVector2Array = []
	#var trans = poly.global_transform
	#for p in poly.polygon:
		#points.append(trans.basis_xform(p))
	
	if Geometry2D.is_point_in_polygon(globals.mpos - poly.global_transform.origin, poly.polygon):
	#if Geometry2D.is_point_in_polygon(globals.mpos, points):
		if Input.is_action_just_pressed("left_click"):
			mouse_down = true
			call_parent()
		if Input.is_action_just_released("left_click"):
			mouse_down = false
			call_parent()

func call_parent():
	poly.get_parent().button_pressed(self)
