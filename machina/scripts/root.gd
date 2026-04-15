extends Node2D

@onready var mouse := $mouse
@onready var resolution := get_viewport().get_visible_rect().size
@onready var center := resolution / 2
@onready var mouse_delta := Vector2.ZERO # filled by _input function here
@export var mouse_slippery := 1
var mouse_trapped:bool = true
var mouse_velocity := Vector2.ZERO

func _ready():
	Engine.max_fps = 60
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	# INIT MOUSE POSITIONS
	mouse.position = center
	globals.mpos = center
func confine_mouse():
	if globals.mpos.x > resolution.x: globals.mpos.x = resolution.x
	if globals.mpos.x < 0: globals.mpos.x = 0
	if globals.mpos.y > resolution.y: globals.mpos.y = resolution.y
	if globals.mpos.y < 0: globals.mpos.y = 0
func _process(delta: float) -> void:
	# MOUSE MOVE LOGIC
	if mouse_trapped:
		mouse_delta = get_global_mouse_position() - center # amount mouse has moved since the previous warp_mouse
		Input.warp_mouse(center)
		if mouse_slippery == 1:
			globals.mpos += mouse_delta # mouse delta filled by _input
			# confine mouse to viewport
			confine_mouse()
			mouse.position = globals.mpos # update position
			mouse_velocity = Vector2.ZERO
		else:
			mouse_velocity += mouse_delta
			globals.mpos += mouse_velocity
			confine_mouse()
			mouse.position = globals.mpos
			mouse_velocity *= mouse_slippery
			
		if Input.is_action_just_pressed("esc"):
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			mouse_trapped = false # pause menu logic here
	else:
		if Input.is_mouse_button_pressed(MouseButton.MOUSE_BUTTON_LEFT): 
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
			globals.mpos = center
			mouse.position = center
			mouse_trapped = true
