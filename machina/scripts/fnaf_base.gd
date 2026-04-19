extends Node2D

var level := 0

@onready var root = get_parent()
@onready var announcer: Announcer = root.announcer
@onready var camera: Camera2D = root.camera
@onready var bays = get_children().filter(func(x): return x.name.contains('Repair Bay'))

var default_character_scene = preload('res://scenes/Character/character.tscn')

func _ready():
	print(bays)

func _start_level(current_level):
	level = current_level
	
	match level:
		1:  
			await get_tree().create_timer(1).timeout
			announcer.announce("Day 1 ~ a fresh start in astrobolt garage", 2, false)
			await announcer.finished
			announcer.announce("use arrow keys to navigate", 5, false)
			await announcer.finished
			cool_nonchalant_bot_strolls_in_to_bay_wyd('res://objects/characters/Wheely.tres', 1)
			announcer.announce("a bot just appeared in bay 1", 3, false)
		2: pass

var grid_camera_position := 5

func _process(delta: float) -> void:
	var gcp: int = grid_camera_position - 1
	var s = Vector2i(get_viewport_rect().size)
	var target_position = Vector2(-s.x + s.x * (gcp%3), - s.y + s.y * floor(gcp/3))
	var t = (target_position - camera.position).length() / 2202
	camera.position = lerp(camera.position, target_position, 0.15)
		
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

func cool_nonchalant_bot_strolls_in_to_bay_wyd(robot:String, bay_number:int):
	#robot can be EITHER scene path or resource path
	var bot_resource = load(robot)
	var bot: Character
	if bot_resource is CharacterResource:
		bot = default_character_scene.instantiate()
		bays[bay_number-1].add_child(bot)
		bot.load_character(bot_resource)
		bot.position = Vector2(1920/2, 1080/2)
	
	
	
