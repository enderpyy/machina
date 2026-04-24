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
var oil_position : Vector2
var charger_position : Vector2

#save data parallels
@onready var calibrator := $"Sensor Calibration"
@onready var nuts := $"Nut Controller"
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
	if save_to_file:
		print("saving to file...")
		save_character()
		return
	
	if current_character == null:
		return
	load_character(current_character)
	print("waitunbg")
	await first_focus # player is on character's tile
	print("husdhf")
	await dialogue_box.says(enter_dialogue)
	print('sdfsdf')
	
	var exploded = await _internal_finished
	if exploded == true:
		hide_all()
		$explosion.show()
		anim.play('explode')
		await anim.animation_finished
	else:
		await dialogue_box.says(exit_dialogue)
	finished.emit(exploded)
	queue_free()

func _process(_d):
	var fully_fixed := true
	for i in [calibrator, nuts, oil, charger]:
		if i and 'status_fixed' in i and i.status_fixed == false:
			fully_fixed = false
			break
	if fully_fixed:
		_internal_finished.emit(false) # exploded = false

func explode():
	_internal_finished.emit(true) # exploded = true

func save_character():
	var fp := "res://objects/characters/" + character_name + ".tres"
	var res : CharacterResource 
	if FileAccess.file_exists(fp):
		res = load(fp)
	else:
		res = CharacterResource.new()
	
	res.character_name = character_name
	res.texture = sprite.texture
	
	res.calibrator_transform = calibrator.transform
	var nut_transforms : Array[Transform2D] = []
	for child in nuts.get_children():
		nut_transforms.append(child.transform)
	res.nut_transforms = nut_transforms
	res.charger_transform = charger.transform
	res.oil_transform = oil.transform
	res.enter_dialogue = enter_dialogue
	res.exit_dialogue = exit_dialogue
	print("saving ", character_name, "...")
	res.wires_transform = wires.transform
	ResourceSaver.save(res, fp)
@onready
var character_area_collision = $"Character Area/CollisionShape2D"
func load_character(char : CharacterResource):
	current_character = char
	sprite.set_texture(char.texture)
	character_name = char.character_name
	calibrator.transform = char.calibrator_transform
	oil.transform = char.oil_transform
	charger.transform = char.charger_transform
	wires.transform = char.wires_transform
	enter_dialogue = char.enter_dialogue
	exit_dialogue = char.exit_dialogue
	#await get_tree().create_timer(10).timeout
	#print('BOOM!')
	#explode()

	

	## create nuts
	#for i in char.nut_transforms:
		#nut = nut_scene.instantiate()
		#nut_controller.add_child(nut)
		#nut.transform = i

func hide_all():
	for i in [calibrator, wires, nuts, oil, charger, sprite]:
		i.hide()
