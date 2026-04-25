class_name Bolt extends RigidBody2D

signal dropped

#sholdve just made a state machine
var following = false
var in_toolbox = false
var connected = false

@onready var detector = $Detector
@onready var sprite = $Sprite
var bolt_name : String = ""

func _process(delta: float) -> void:
	if following:
		linear_velocity = (get_global_mouse_position() - global_position)*10

func set_color(c : Color): # called by computer
	sprite.modulate = c

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	#print("clicking?")
	if event.is_action_pressed("left_click") and !connected:
		if following == false and globals.nut == null:
			follow_mouse(true)
		elif following == true:
			follow_mouse(false)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click") and following == true and !connected:
		follow_mouse(false)
		#for area in detector.get_overlapping_areas():
			#if area.has_method("accept_bolt"):
				#area.accept_bolt(self)

func follow_mouse(b):
	if b == true:
		globals.nut = self
		following = true
		#print("not colliding")
		set_collision_layer_value(2, false)
		set_collision_mask_value(2, false)
		enter_toolbox(false)
	else:
		if in_toolbox:
			enter_toolbox(true)
		else:
			#print("collision working")
			set_collision_layer_value(2, true)
			set_collision_mask_value(2, true)
		following = false
		globals.nut = null

func pop_bolt(): # called by the computer
	var angle = -randf_range(45.0, 135.0)
	var direction = Vector2(cos(deg_to_rad(angle)), sin(deg_to_rad(angle)))
	#apply_torque_impulse(1000000)
	apply_force(direction * 20000)

func enter_toolbox(b : bool):
	print('entering')
	if b:
		set_collision_layer_value(3, true)
		set_collision_mask_value(3, true)
	else:
		set_collision_layer_value(3, false)
		set_collision_mask_value(3, false)
