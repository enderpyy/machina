extends Node2D

@onready var mouse := $mouse
@onready var center := get_viewport().get_visible_rect().size / 2
@onready var mouse_delta := Vector2.ZERO # filled by _input function here
var mouse_trapped:bool = true

func _ready():
	Engine.max_fps = 60
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	# INIT MOUSE POSITIONS
	mouse.position = center
	globals.mpos = center

func _process(delta: float) -> void:
	# MOUSE MOVE LOGIC
	if mouse_trapped:
		mouse_delta = get_global_mouse_position() - center  # amount mouse has moved since the previous warp_mouse
		Input.warp_mouse(center)
		globals.mpos += mouse_delta # mouse delta filled by _input
		mouse.position = globals.mpos
		
		if Input.is_action_just_pressed("esc"):
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			mouse_trapped = false # pause menu logic here
	else:
		if Input.is_mouse_button_pressed(MouseButton.MOUSE_BUTTON_LEFT): 
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
			globals.mpos = center
			mouse.position = center
			mouse_trapped = true
