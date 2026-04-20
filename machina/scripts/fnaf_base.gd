class_name FNAF_base extends Node2D

var level := 0

@onready var root = get_parent()
@onready var announcer: Announcer = root.announcer
@onready var camera: Camera2D = root.camera
@onready var bays: Array[Node] = get_children().filter(func(x): return x.name.contains('Repair Bay'))
@onready var anim: AnimationPlayer = $AnimationPlayer
var in_focus := true

var default_character_scene = preload('res://scenes/Character/character.tscn')


func _ready():
	bays.insert(4, null) # so the fourth bay is where u are

func _start_level(current_level):
	level = current_level
	
	match level:
		1: 
			await get_tree().create_timer(1).timeout
			anim.play('space_approach')
			show()
			await anim.animation_finished
			announcer.announce("Day 1 ~ a fresh start in astrobolt garage", 3, false)
			await announcer.finished
			#announcer.announce("use WASD/arrows to navigate rooms", 5, false)
			#await announcer.finished
			cool_nonchalant_bot_strolls_in_to_bay_wyd('res://objects/characters/Wheely.tres', 1)
			announcer.announce("a bot just appeared in bay 1", 1.5, false)
		2: 
			pass

var grid_camera_position := 5

func _process(delta: float) -> void:
	var gcp: int = grid_camera_position - 1
	var s = Vector2i(get_viewport_rect().size * 0.9)
	var target_position = Vector2(-s.x + s.x * (gcp%3), - s.y + s.y * floor(gcp/3))
	var t = (target_position - camera.position).length() / 2202
	camera.position = lerp(camera.position, target_position, 0.15)
		
func _input(event: InputEvent) -> void:
	var old_grid = grid_camera_position
	
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
	
	if old_grid != grid_camera_position:
		var b = bays[grid_camera_position-1]
		print(b)
		if b and b.current_character:
			print("CHAR FOUND")
			b.current_character.on_focus()

func cool_nonchalant_bot_strolls_in_to_bay_wyd(robot:String, bay_number:int):
	#robot can be EITHER scene path or resource path
	var bot_resource = load(robot)
	var bot: Character
	var bay:RepairBay = bays[bay_number-1]
	if bot_resource is CharacterResource:
		bot = default_character_scene.instantiate()
		bay.add_child(bot)
		bot.load_character(bot_resource)
		bot.position = Vector2(1920/2, 1080/2)
		bay.status_indicator.blink_red()
		bay.current_character = bot
	
	
	
