extends Node2D

var level := 0

@onready var root = get_parent()
@onready var announcer: Announcer = root.announcer
@onready var camera: Camera2D = root.camera
@onready var bays = [$'Repair Bay 5']

func _start_level(current_level):
	level = current_level
	
	match level:
		1:  
			await get_tree().create_timer(1).timeout
			
			announcer.announce("now take a dump for me on camera", 1.5, false)
			await announcer.finished
			await get_tree().create_timer(1).timeout
			announcer.announce("faster!", 1, true)
			# code for level 1
			
		2: pass

var grid_camera_position := 5

func _process(delta: float) -> void:
	var gcp: int = grid_camera_position - 1
	var s = Vector2i(get_viewport_rect().size)
	var target_position = Vector2(-s.x + s.x * (gcp%3), - s.y + s.y * floor(gcp/3))
	var t = (target_position - camera.position).length() / 2202
	camera.position = lerp(camera.position, target_position, 0.2)
		
func _input(event: InputEvent) -> void:
	if event.is_action_pressed('left'):
		grid_camera_position -= 1
	if event.is_action_pressed('right'):
		grid_camera_position += 1
	if event.is_action_pressed('up'):
		grid_camera_position -= 3
	if event.is_action_pressed('down'):
		grid_camera_position += 3
	if grid_camera_position < 1: grid_camera_position = 1
	if grid_camera_position > 9: grid_camera_position = 9
