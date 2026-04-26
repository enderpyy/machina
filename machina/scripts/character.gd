class_name Character extends Node2D

@export
var character_name : String
@export
var save_to_file : bool
@export
var current_character : CharacterResource
@export
var enter_dialogue : Array[String] = ['hey shawty']
var exit_dialogue : Array[String] = ['bye shawty']
#save data
var calibrator_position : Vector2
var nut_positions : Array[Vector2]
var charger_position : Vector2
var explode_time : float
var desired_bolt_color : Color
#save data parallels
@onready var calibrator := $"Sensor Calibration"
@onready var nuts := $bolts
@onready var oil := $oil
@onready var charger := $charger
@onready var wires := $Wires

@onready var audio := $AudioStreamPlayer2D
@onready var dialogue_box := $DialogueBox

@onready var sprite : Sprite2D = $"Main Sprite"
@onready var anim := $AnimationPlayer

var duration := 10.0 # SAVE HIM bar with a countdown of this duration...

signal first_focus # called by parent when on the tile with character
signal _internal_finished(exploded)
signal finished(exploded)

var ready_to_be_repaired := false

func _ready() -> void:
	print('LETS GO!')
	if save_to_file:
		save_character()
		return
	
	if current_character == null:
		return
	print('loading character')
	load_character(current_character)
	print('loaded!')
	get_parent().start_countdown(explode_time)
	await first_focus # player is on character's tile
	print('first focsu!')
	await dialogue_box.says(enter_dialogue)
	var exploded = await _internal_finished
	charger.force_disconnect()
	get_parent().stop_status_indicator()
	get_parent().diffuse_bomb()
	exit(false)

func exit(exploded):
	if exploded:
		hide_all()
		$explosion.show()
		anim.play('explode')
		await anim.animation_finished
	else:
		await dialogue_box.says(exit_dialogue)
		anim.play('leave')
	finished.emit(exploded)
	queue_free()

func _process(_d):
	var fully_fixed := true
	for i in [calibrator, nuts, charger, wires]:
		if i and 'status_fixed' in i and i.status_fixed == false:
			fully_fixed = false
			break
	if fully_fixed:
		_internal_finished.emit(false) # exploded = false

func explode():
	exit(true)

func save_character():
	var fp := "res://objects/characters/" + character_name + ".tres"
	var res : CharacterResource 
	if FileAccess.file_exists(fp):
		res = load(fp)
	else:
		res = CharacterResource.new()
	
	res.sprite_transform = sprite.transform
	res.character_name = character_name
	res.texture = sprite.texture
	res.explode_time = explode_time
	res.calibrator_transform = calibrator.transform
	var nut_transforms : Array[Transform2D] = []
	for child in nuts.get_children():
		#print("1 child")
		nut_transforms.append(child.transform)
	#res.nut_transforms = nut_transforms
	res.charger_transform = charger.transform
	res.enter_dialogue = enter_dialogue
	res.exit_dialogue = exit_dialogue
	res.bolt_transforms = nut_transforms
	#print("nut transforms " + str(nut_transforms))
	for bolt in nuts.get_children():
		if bolt is BoltSocket:
			res.default_bolt_color = bolt.modulate
	print("saving ", character_name, "...")
	res.wires_transform = wires.transform
	ResourceSaver.save(res, fp)
@onready
var character_area_collision = $"Character Area/CollisionShape2D"
var bolt_scene = preload("res://scenes/bolt_socket.tscn")
func load_character(char : CharacterResource):
	current_character = char
	sprite.set_texture(char.texture)
	sprite.transform = char.sprite_transform
	character_name = char.character_name
	if current_character.problems["calibrator"]:
		calibrator.transform = char.calibrator_transform
		calibrator.status_fixed = false
	else:
		disable_node(calibrator)
	if current_character.problems["charger"]:
		charger.transform = char.charger_transform
		charger.status_fixed = false
	else:
		disable_node(charger)
	if current_character.problems["wires"]:
		wires.transform = char.wires_transform
		print('WIRES STATUS FALSE!')
		wires.status_fixed = false
	else:
		disable_node(wires)
	for child in nuts.get_children():
		child.queue_free()
	if current_character.problems["nut"]:
		nuts.status_fixed = false
		desired_bolt_color = current_character.desired_bolt_color
		print('get set')
		for bolt in current_character.bolt_transforms:
			var b = bolt_scene.instantiate()
			nuts.add_child(b)
			b.transform = bolt
			b.bolt.set_color(current_character.default_bolt_color)
		
	#if current_character.problems["screws"]:
	#	pass
	enter_dialogue = char.enter_dialogue
	exit_dialogue = char.exit_dialogue
	explode_time = char.explode_time
	

	## create nuts
	#for i in char.nut_transforms:
		#nut = nut_scene.instantiate()
		#nut_controller.add_child(nut)
		#nut.transform = i

func hide_all():
	for i in [calibrator, wires, nuts, charger, sprite]:
		if i: i.hide()

func disable_node(n: Node2D):
	if n and 'status_fixed' in n: 
		n.status_fixed = true
	n.process_mode = Node.PROCESS_MODE_DISABLED
	n.visible = false

var charge : float = 0.0
func charge_up(delta):
	charge += current_character.charge_rate * delta/60
	charge = clamp(0, 1.0, charge)
	if charge == 1.0:
		charger.status_fixed = true

var zoomed_in := false
