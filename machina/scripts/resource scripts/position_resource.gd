class_name PositionResource extends Resource

func build(node : Node2D):
	
	set_position(node.get_position())
	set_scale(node.get_scale())
	set_rotation(node.get_rotation())
	

var position : Vector2
var scale : Vector2
var rotation : float

func set_position(v : Vector2):
	position = v
func get_position() -> Vector2:
	return position
func set_scale(s : Vector2):
	scale = s
func get_scale() -> Vector2:
	return scale
func set_rotation(r : float):
	rotation = r
func get_rotation() -> float:
	return rotation
