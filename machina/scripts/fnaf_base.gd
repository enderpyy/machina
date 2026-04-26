class_name FNAF_base extends Node2D

var level := 0

@onready var root = get_parent()
@onready var announcer: Announcer = root.announcer
@onready var camera: Camera2D = root.camera
@onready var bays: Array[Node] = get_children().filter(func(x): return x.name.contains('Repair Bay'))
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var self_dialogue := $SelfDialogue
@onready var customers_left_label := $Screen/scale/Label
var n_customers_left := 0
var in_focus := true
var things_left_to_do := 0 # spawning a bot adds 1, finishing a bot subtracts 1. keeps the level from ending early
var all_tasks_failed_successfully = true # set to false if you kill a bot
signal completed(passed:bool, score:int)

var default_character_scene = preload('res://scenes/Character/character.tscn')


func _ready():
	hide()
	bays.insert(4, null) # so the fifth bay is where u are

func set_customers_left_screen():
	customers_left_label.text = 'Customers left: ' + str(n_customers_left)

func _start_level(current_level):
	level = current_level
	hide()
	await get_tree().create_timer(1).timeout
	anim.play('space_approach', -1, 0.8)
	show()
	await anim.animation_finished
	$televisions.show()
	await get_tree().create_timer(0.7).timeout
	
	match level:
		1: 
			n_customers_left = 4 # SET THIS NUMBER RIGHT its the number of robots you help this day. To appear on the screen in base
			set_customers_left_screen()
			await announcer.announce("Day 1 ~ a fresh start on E381", 3, false)
			self_dialogue.says(['p  o  w  e  r  i  n  g .    .   .     .    .   u  p   .    .    .     .', 'welcome to my chassis, master...', 'today, you will be doing customer repairs... ', 'you are virtually visiting ship E381 - earth proximity: 3.1bil light years', 'so dont mind the lag...', ''])
			await self_dialogue.closed
			await announcer.announce("use WASD/arrows to navigate rooms", 5, false)
			## ALL FOUR EXAMPLE CHARACTERS INSTANT SPAWN
			spawn_after_await(0.0, 'res://objects/characters/NeedCalibrate.tres', 1)
			spawn_after_await(0.0, 'res://objects/characters/YellowNuts.tres', 3)
			spawn_after_await(0.0, 'res://objects/characters/MixedWires.tres', 9)
			spawn_after_await(0.0, 'res://objects/characters/Chargim.tres', 4)
			
			announcer.announce("a bot just appeared in bay 1", 1.5, false)
			await self_dialogue.says(['my records indicate you were fired from your last job on G1-008...', ''])
			await announcer.announce("this bot yap too much", 1.5, false)
			
			while things_left_to_do > 0:
				await get_tree().process_frame
			
			exit()
		2: 
			n_customers_left = 1
			set_customers_left_screen()
			await announcer.announce("Day 2 ~ meeting dicky dan", 3, false)
			await self_dialogue.says(['just be glad youre not meeting dicky frank.', ''])
			spawn_after_await(30.0, 'res://objects/characters/Chargim.tres', 4)
			
			while things_left_to_do > 0:
				await get_tree().process_frame
			
			exit()
		3:
			n_customers_left = 2
			set_customers_left_screen()
			await announcer.announce("Day 3 ~ meeting dicky frank", 3, false)
			await self_dialogue.says(['RUN!!!!', ''])
			spawn_after_await(0.0, 'res://objects/characters/YellowNuts.tres', 3)
			spawn_after_await(0.0, 'res://objects/characters/MixedWires.tres', 9)

			while things_left_to_do > 0:
				await get_tree().process_frame
			
			exit()

var grid_camera_position := 5

func exit():
	grid_camera_position = 5
	Signals.hide_all_bolts.emit()
	anim.play_backwards('space_approach')
	await anim.animation_finished
	completed.emit(all_tasks_failed_successfully)
	queue_free()

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

func spawn_after_await(time:float, robot:String, bay_number:int): # dont call directly
	#robot can be EITHER scene path or resource path
	things_left_to_do += 1
	if time > 0.0: await get_tree().create_timer(time).timeout
	
	var bot_resource = load(robot)
	var bot: Character
	var bay:RepairBay = bays[bay_number-1]
	assert(bay, 'thats the index of the middle bay probably idk pick another number')
	if bot_resource is CharacterResource:
		bot = default_character_scene.instantiate()
		bot.current_character = bot_resource
		bay.add_child(bot)
		bot.position = Vector2(1920/2, 1080/2)
		bay.status_indicator.blink_red()
		bay.current_character = bot
	else: # attempts to instance whatever you put
		print('WARNING: check this is behavior you want in fnaf_base.gd')
		bot = bot_resource.instantiate()
		bay.add_child(bot)
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
		exit()
	else:
		n_customers_left -= 1
		set_customers_left_screen()
		things_left_to_do -= 1
