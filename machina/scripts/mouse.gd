extends Node2D
@onready var viewport = get_viewport()
@onready var resolution = viewport.get_visible_rect().size
@onready var center: Vector2 = resolution / 2
@onready var mouse_movement_center: Vector2 = center
@onready var virtual_mpos := center # filled by _input function here
@onready var sprite = $sprite

@export var disable_custom_mouse := false
@export var mouse_slippery := 1.0 # 1 for no slip, 2 to 150 for varying slip
@export var mouse_damping := 1.0 # 1.0 is no damping, decrease for more damping. multiplied into the mouse velocity every frame

var mouse_trapped:bool = true
var mouse_velocity := Vector2.ZERO

func _ready():
	if not disable_custom_mouse:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	# INIT MOUSE POSITIONS
	position = center
	globals.mpos = center
	#apply_mouse_slippery(2, 0.5)

func apply_mouse_slippery(acceleration, damping):
	mouse_slippery = acceleration
	mouse_damping = damping

func confine_mouse():
	if globals.mpos.x > resolution.x: globals.mpos.x = resolution.x
	if globals.mpos.x < 0: globals.mpos.x = 0
	if globals.mpos.y > resolution.y: globals.mpos.y = resolution.y
	if globals.mpos.y < 0: globals.mpos.y = 0

func _process(_d):
	resolution = get_viewport().get_visible_rect().size
	center = resolution / 2
	
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		sprite.frame = 1
	else:
		sprite.frame = 0
	
	if mouse_trapped:
		#print(DisplayServer.get_mouse_posiotion)
		if mouse_slippery == 1:
			pass#globals.mpos += virtual_mpos # mouse delta filled by _input
			#var inp := InputEventMouseMotion.new()
			#inp.screen_relative = virtual_mpos
			#Input.parse_input_event(inp)
			#virtual_mpos = Vector2.ZERO
			## confine mouse to viewport
			#confine_mouse()
			#position = get_global_mouse_position() # update position
			#mouse_velocity = Vector2.ZERO
		else:
			pass
			#mouse_velocity += virtual_mpos / mouse_slippery
			#mouse_velocity *= mouse_damping
			#globals.mpos += mouse_velocity
			#confine_mouse()
			#position = globals.mpos
			#mouse_movement_center = globals.mpos
			#Input.warp_mouse(center)
			
		if Input.is_action_just_pressed("esc"):
			 #for if we ever make this a desktop game, and you need to be able to release ur mouse:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			mouse_trapped = false 
			
	else:
		if Input.is_mouse_button_pressed(MouseButton.MOUSE_BUTTON_LEFT): 
			if not disable_custom_mouse: Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			else: Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN) 
			globals.mpos = center
			position = center
			mouse_trapped = true

func _input(event: InputEvent) -> void:
	''' cancel incoming mouse inputs, duplicate the event, change event's position propery to an arbitrary virtual mouse input, then push input to the viewport. '''
	if not event.has_meta("is_virtual") and (event is InputEventMouse): # check for the is_virtual meta, which only appears on my virtual inputs.
		if disable_custom_mouse:
			position = event.position
			return
				
		viewport.set_input_as_handled() # stop the raw input event from propogating
		if event is InputEventMouseMotion:
			position += event.screen_relative # for moving the virtual mouse
			var inp = event.duplicate() # duplicate input event
			inp.set_meta("is_virtual", true) # add the is_virtual metadata
			inp.position = position # change the position information
			inp.global_position = position
			#Input.parse_input_event(inp)
			viewport.push_input(inp, true) # push input to viewport
		elif event is InputEventMouseButton:
			var inp = event.duplicate()
			inp.set_meta("is_virtual", true)
			inp.position = position
			inp.global_position = position
			#Input.parse_input_event(inp)
			viewport.push_input(inp, true)
		

# ButtonArea:<Area2D#39745226183>	InputEventMouseButton: button_index=1, mods=none, pressed=true, canceled=false, position=((414.0, 326.0)), button_mask=1, double_click=false

		#elif event is InputEventKey:
			#print(event)
			#pass
			#var inp := event.duplicate()
			#inp.set_meta("is_virtual", true)
			#inp.global_position = position
			#inp.position = position
			#Input.parse_input_event(inp)
