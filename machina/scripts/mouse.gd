extends Node2D
@onready var resolution = get_viewport().get_visible_rect().size
@onready var center = resolution / 2
@onready var mouse_movement_center = center
@onready var mouse_delta := Vector2.ZERO # filled by _input function here

@export var mouse_slippery := 1.0 # 1 for no slip, 2 to 150 for varying slip
@export var mouse_damping := 1.0 # 1.0 is no damping, decrease for more damping. multiplied into the mouse velocity every frame

var mouse_trapped:bool = true
var mouse_velocity := Vector2.ZERO

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	# INIT MOUSE POSITIONS
	position = center
	globals.mpos = center

func apply_mouse_slippery(acceleration, damping):
	mouse_slippery = acceleration
	mouse_damping = damping

func confine_mouse():
	if globals.mpos.x > resolution.x: globals.mpos.x = resolution.x
	if globals.mpos.x < 0: globals.mpos.x = 0
	if globals.mpos.y > resolution.y: globals.mpos.y = resolution.y
	if globals.mpos.y < 0: globals.mpos.y = 0


func _process(_d):
	if mouse_trapped:
		prints(get_viewport().get_mouse_position())
		mouse_delta = get_global_mouse_position() - mouse_movement_center # amount mouse has moved since the previous warp_mouse
		if mouse_slippery == 1:
			globals.mpos += mouse_delta # mouse delta filled by _input
			# confine mouse to viewport
			confine_mouse()
			position = globals.mpos # update position
			mouse_velocity = Vector2.ZERO
			mouse_movement_center = globals.mpos
			Input.warp_mouse(mouse_movement_center)
		else:
			mouse_velocity += mouse_delta / mouse_slippery
			mouse_velocity *= mouse_damping
			globals.mpos += mouse_velocity
			confine_mouse()
			position = globals.mpos
			mouse_movement_center = globals.mpos
			Input.warp_mouse(mouse_movement_center)
			
		if Input.is_action_just_pressed("esc"):
			 #for if we ever make this a desktop game, and you need to be able to release ur mouse:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			mouse_trapped = false 
			
	else:
		if Input.is_mouse_button_pressed(MouseButton.MOUSE_BUTTON_LEFT): 
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
			globals.mpos = center
			position = center
			mouse_trapped = true
