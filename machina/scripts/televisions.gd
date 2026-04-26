extends CanvasLayer

@onready var youarehere = $YouAreHere
@onready var camera = get_parent().camera
@onready var center_position = youarehere.position
func _process(_d):
	if not camera:
		camera = get_parent().camera
		return
	var relative_position = camera.global_position * Vector2(float(123*1.0)/2233, float(78*1.0)/1950)
	youarehere.position = center_position + relative_position
