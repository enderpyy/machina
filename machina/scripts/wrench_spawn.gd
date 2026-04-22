class_name WrenchSpawn extends Node2D

@onready
var wrench_pivot_body = $"Pivot controller/Wrench Pivot Body"
@onready
var wrench = $Wrench
@onready
var bolt_detection_area = $"Wrench/Bolt Detection Area"



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
			pass#pivot_controller.linear_velocity -= (1/(pivot_controller.linear_velocity.length()/20 + 1))pivot_controller.linear_velocity
#search for nearby sockets
	var nearest_bolt : BoltArea
	var nearest_dist : Vector2
	for area in bolt_detection_area.get_overlapping_areas():
		if area is BoltArea:
			#print("bolt in range")
			if area.get_parent().get_parent().has_bolt():
				var area_dist = (bolt_detection_area.global_position - area.global_position)
				if nearest_bolt == null:
					nearest_bolt = area
					nearest_dist = area_dist
				elif nearest_dist.length() > area_dist.length():
					nearest_bolt = area
					nearest_dist = area_dist
	
	#lean towards closest based on range
	if following and nearest_bolt != null:
		#print("force applied")
		var target_angle = -nearest_dist.angle()
		var error = angle_difference(wrench.rotation, target_angle)
		var torque = 200 * error - 20 * angular_velocity
		wrench.apply_torque(torque)
		#self.rotation = lerp(self.rotation, nearest_dist.angle(), 0.05)
var angular_velocity = 2000000000
@onready var pivot_controller = $"Pivot controller"
var on_bolt = false

@onready var bolt_joint = $"Wrench/Bolt Area/Bolt Joint"
@onready var bolt_pivot = $"Wrench/Bolt Area/StaticBody2D"
func lock_on_bolt(b : bool):
	if b:
		bolt_joint.node_a = wrench.get_path()
	else:
		bolt_joint.node_a = bolt_pivot.get_path()
	bolt_joint.top_level = b

func _on_bolt_area_area_entered(area: Area2D) -> void:
	if area is BoltArea:
		pivot_controller.swap_joint()
		on_bolt = true
		#lock_on_bolt(true)
		#switch to spring pivot


func _on_bolt_area_area_exited(area: Area2D) -> void:
	if area is BoltArea:
		pivot_controller.swap_joint()
