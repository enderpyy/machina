class_name WrenchSpawn extends Node2D

@onready
var wrench_pivot_body = $"Pivot controller/Wrench Pivot Body"
@onready
var wrench = $Wrench



var following := false
func _on_wrench_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("left_click"):
		pivot_controller.freeze = false
		following = true

var max_speed = 500.0
func _process(delta: float) -> void:
	if following:
		var v = (get_global_mouse_position()-pivot_controller.global_position)*10#.limit_length(max_speed)
		pivot_controller.linear_velocity = v
		if on_bolt:
			pass#pivot_controller.linear_velocity -= (1/(pivot_controller.linear_velocity.length()/20 + 1))*pivot_controller.linear_velocity

@onready var pivot_controller = $"Pivot controller"
var on_bolt = false

func _on_bolt_area_area_entered(area: Area2D) -> void:
	if area is BoltArea:
		pivot_controller.swap_joint()
		on_bolt = true
		#switch to spring pivot


func _on_bolt_area_area_exited(area: Area2D) -> void:
	if area is BoltArea:
		pivot_controller.swap_joint()
