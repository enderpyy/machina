extends Polygon2D

@onready var your_reflection:= $your_reflection
var cam_offset := Vector2(1920/2, 1080/2 + 150)
var bounce_on_it := 0.0

func _process(delta: float) -> void:
	var campos = get_viewport().get_camera_2d().position + cam_offset
	your_reflection.position = campos + Vector2(0, 10*sin(bounce_on_it))
	bounce_on_it += 0.05
