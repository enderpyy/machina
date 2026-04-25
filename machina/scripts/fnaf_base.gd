class_name FNAF_base extends Node2D

var level := 0

@onready var root = get_parent()
@onready var announcer: Announcer = root.announcer
@onready var camera: Camera2D = root.camera
@onready var bays: Array[Node] = get_children().filter(func(x): return x.name.contains('Repair Bay'))
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var self_dialogue := $SelfDialogue
var in_focus := true
var things_left_to_do := 0 # spawning a bot adds 1, finishing a bot subtracts 1. keeps the level from ending early
var all_tasks_failed_successfully = true # set to false if you kill a bot
signal completed(passed:bool, score:int)

var default_character_scene = preload('res://scenes/Character/character.tscn')


func _ready():
	bays.insert(4, null) # so the fourth bay is where u are

func _start_level(current_level):
	level = current_level
	hide()
	await get_tree().create_timer(1).timeout
	anim.play('space_approach')
	show()
	await anim.animation_finished
	$televisions.show()
	await get_tree().create_timer(0.7).timeout
	
	match level:
		1: 
			await announcer.announce("Day 1 ~ a fresh start on E381", 3, false)
			self_dialogue.says(['p  o  w  e  r  i  n  g .    .   .     .    .   u  p   .    .    .     .', 'welcome to my chassis, master...', 'today, you will be doing customer repairs... ', 'you are virtually visiting ship E381 - earth proximity: 3.1bil light years', 'so dont mind the lag...', ''])
			await self_dialogue.closed
			await announcer.announce("use WASD/arrows to navigate rooms", 5, false)

			#await announcer.finished
			cool_nonchalant_bot_strolls_in_to_bay_wyd('res://objects/characters/Chargim.tres', 1)
			announcer.announce("a bot just appeared in bay 1", 1.5, false)
			await self_dialogue.says(['my records indicate you were fired from your last job on E1008...', ''])
			await announcer.announce("this bot yap too much", 1.5, false)
			
			while things_left_to_do > 0:
				await get_tree().process_frame
			grid_camera_position = 5
			anim.play_backwards('space_approach')
			await anim.animation_finished
			completed.emit(all_tasks_failed_successfully)
			queue_free()
		2: 
			await announcer.announce("Day 2 ~ meeting dicky dan", 3, false)

var grid_camera_position := 5

func _process(delta: float) -> void:
	var gcp: int = grid_camera_position - 1
	var s = Vector2i(2233, 1950)
	var target_position = Vector2(-s.x + s.x * (gcp%3), - s.y + s.y * floor(gcp/3))
	var t = (target_position - camera.position).length() / 2202
	camera.position = lerp(camera.position, target_position, 0.15)
	
	#if camera.position.length() <= 40 and :
	
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
		if b and b.current_character:
			await get_tree().create_timer(0.6).timeout
			b.current_character.first_focus.emit()

func cool_nonchalant_bot_strolls_in_to_bay_wyd(robot:String, bay_number:int):
	#robot can be EITHER scene path or resource path
	things_left_to_do += 1
	
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
	
	if bay_number == grid_camera_position:
		await get_tree().create_timer(0.6).timeout
		bot.first_focus.emit()
	
	var exploded = await bot.finished
	if exploded == true:
		things_left_to_do -= 1
		all_tasks_failed_successfully = false
	else:
		things_left_to_do -= 1
	
func spawn_guy_in_time(robot, bay_number, time):
	await get_tree().create_timer(time).timeout
	cool_nonchalant_bot_strolls_in_to_bay_wyd(robot, bay_number)
