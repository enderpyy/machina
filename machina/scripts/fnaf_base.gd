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
			n_customers_left = 5 # SET THIS NUMBER RIGHT its the number of robots you help this day. To appear on the screen in base
			set_customers_left_screen()
			await announcer.announce("Day 1 ~ a fresh start on E381", 3, false)
			self_dialogue.says(['p  o  w  e  r  i  n  g .    .   .     .    .   u  p   .    .    .     .', 'welcome to my chassis, master...', 'today, you will be doing customer repairs... ', 'you are virtually visiting ship E381 - earth proximity: 3.1bil light years', 'so dont mind the lag...', 'Robots are gonna come in. You have to help them out', 'No matter the problem', 'All these bots are way too picky though', 'Take too long, and theyll just leave, without paying', 'make sure youre paying attention to who comes in on your cameras', 'and listen to EVERYTHING they say', 'or they wont leave', 'good luck on your first day!', ''])
			await self_dialogue.closed
			await announcer.announce("use WASD/arrows to navigate rooms", 5, false)
			## ALL FOUR EXAMPLE CHARACTERS INSTANT SPAWN
			spawn_after_await(0.0, 'res://objects/characters/NeedCalibrate.tres', 1)
			spawn_after_await(0.0, 'res://objects/characters/Chargim.tres', 4, true, 1)
			spawn_after_await(10.0, 'res://objects/characters/chargibrate.tres', 6, true, 2)
			spawn_after_await(22.0, 'res://objects/characters/Chargim2.tres', 8, true, 2)
			spawn_after_await(25.0, 'res://objects/characters/chargibrate2.tres', 2, true, 2)
			
			announcer.announce("a bot just appeared in bay 1", 1.5, false)
			await self_dialogue.says(['my records indicate you were fired from your last job on G1-008...', ''])
			await announcer.announce("this bot yap too much", 1.5, false)
			
			while things_left_to_do > 0:
				await get_tree().process_frame
			
			exit()
		2: 
			n_customers_left = 5
			set_customers_left_screen()
			await announcer.announce("Day 2 ~ things get nuts", 3, false)
			await self_dialogue.says(['People have been coming in with a lot of complaints lately.', 'Saying they need their bolts replaced', "I guess you could say...", "They've got their 'screws loose'", ">:)", 'between you and me, I just change the color and give them the same kind', 'You can print them out at that computer there', 'Theyll tell you what color they want, make sure you remember, type it in for a new bolt', "its a 'HEX code'", 'haha', 'get it?', '...', 'The old thing stinks though, so be ready for a wait', 'Good luck', ''])
			spawn_after_await(0.0, 'res://objects/characters/bolts_day2.tres', 2)
			spawn_after_await(0.0, 'res://objects/characters/calibolts_day2.tres', 1, true, 1)
			spawn_after_await(2.0, 'res://objects/characters/chargibrate_day2.tres', 6, true, 1)
			spawn_after_await(30.0, 'res://objects/characters/chargibolts_day2.tres', 4, true, 1)
			spawn_after_await(47.0, 'res://objects/characters/calibrate_day2.tres', 9, true, 1)
			#spawn_after_await(40.0, 'res://objects/characters/chargibrate2.tres', 7, true, 1)
			
			while things_left_to_do > 0:
				await get_tree().process_frame
			
			exit()
		3:
			n_customers_left = 8
			set_customers_left_screen()
			await announcer.announce("Day 3 ~ wired", 3, false)
			await self_dialogue.says(["You'd think that the problems would be getting fewer and far between with all this new tech", 'But no', 'New problems every day', 'Robots are gonna come in asking for their wires fixed', 'You gotta fix them', 'Ever played among us?', 'Never mind', 'I hope youre not colorblind', ''])
			#spawn_after_await(0.0, 'res://objects/characters/big_bad.tres', 1)
			spawn_after_await(0.0, 'res://objects/characters/wires.tres', 2)
			spawn_after_await(0.0, 'res://objects/characters/warger.tres', 4, true, 1)
			spawn_after_await(10.0, 'res://objects/characters/wolts.tres', 3, true, 1)
			spawn_after_await(0.0, 'res://objects/characters/big_bad.tres', 1, true, 3)
			spawn_after_await(30.0, 'res://objects/characters/wires_1.tres', 7, true, 3)
			spawn_after_await(36.0, 'res://objects/characters/wires_2.tres', 8, true, 3)
			spawn_after_await(40.0, 'res://objects/characters/wires_3.tres', 9, true, 3)
			#spawn_after_await(90.0, 'res://objects/characters/cali_wolts.tres', 2, true, 1)

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
			if b and b.current_character:
				b.current_character.first_focus.emit()

@onready var alert = $Alert
func spawn_after_await(time:float, robot:String, bay_number:int, next_bot:bool = false, next_bot_count:int = 1): # dont call directly
	#robot can be EITHER scene path or resource path
	things_left_to_do += 1
	
	if next_bot:
		for i in range(next_bot_count):
			await bot_left
	if time > 0.0: await get_tree().create_timer(time).timeout
	
	alert.play()
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
	bot_left.emit()
	if exploded == true:
		things_left_to_do -= 1
		all_tasks_failed_successfully = false
		exit()
	else:
		n_customers_left -= 1
		set_customers_left_screen()
		things_left_to_do -= 1

signal bot_left
