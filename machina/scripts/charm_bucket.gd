extends RigidBody2D

@onready var grab_area = $"Grab Area"
var on_screen = false

var all_accessories = []
func _ready():
	pass


@onready var animator = $animator
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("bag"):
		if on_screen:
			on_screen = false
		else:
			on_screen = true


@export var path: Curve
@export var offset: float = 700
func _process(d):
	if on_screen:
		var dist = -((290.0 - position.x-790)/790.0)
		var weight = path.sample(dist) * 0.1
		position.x = lerp(position.x, 0.0, weight)
	else:
		var dist = ((-500.0 - position.x-790)/790.0)
		var weight = path.sample(dist) * 0.2
		position.x = lerp(position.x, -offset, weight)
	
	var mp = get_local_mouse_position()
	if following and mp.x < 0 and mp.x > -offset:
		self.position = mp - mouse_offset

func phase_out():
	for child in get_children():
		if child is RigidBody2D:
			child.set_collision_layer_value(1, false)
			child.set_collision_mask_value(1, false)

func phase_in():
	for child in get_children():
		if child is RigidBody2D:
			child.set_collision_layer_value(1, true)
			child.set_collision_mask_value(1, true)


var mouse_offset : Vector2
var following = false
func _on_grab_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if Input.is_action_just_pressed("left_click"):
		print("clicked?")
		following = true
		mouse_offset = get_local_mouse_position()
	if Input.is_action_just_released("left_click"):
		following = false
