extends Node2D

var percent := 100
@onready var slide = $Polygon2D/slider
func _process(_d):
	slide.position.x = 0-647.0 * 0.01 * percent
