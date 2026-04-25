extends Node2D


@export var percent := 1.0
@onready var slide = $Polygon2D/slider
func _process(_d):
	slide.position.x = -647.0 + 647.0 * percent
