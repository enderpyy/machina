class_name WrenchSpawn extends Node2D

@onready
var wrench_pivot = $"Wrench Pivot/Wrench Pivot Body"


var following := false
func _on_wrench_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("left_click"):
		wrench_pivot.freeze = false
		following = true

var max_speed = 500.0
func _process(delta: float) -> void:
	if following:
		var v = (get_global_mouse_position()-wrench_pivot.global_position)*10#.limit_length(max_speed)
		wrench_pivot.linear_velocity = v
