class_name Character extends Node2D

@export
var character_name : String
@export
var save_to_file : bool
@export
var current_character : CharacterResource

#save data
var calibrator_position : Vector2
var nut_positions : Array[Vector2]
var oil_position : Vector2
var charger_position : Vector2

#save data parallels
@onready var calibrator = $"Sensor Calibration"
@onready var nuts = $"Nut Controller"
@onready var oil = $oil
@onready var charger = $oil
@onready var audio = $AudioStreamPlayer2D

@onready
var sprite : Sprite2D = $"Main Sprite"

func _ready() -> void:
	print("ready")
	if save_to_file:
		print("saving to file...")
		save_character()
		return
	
	if current_character != null:
		print('loading: ', current_character.character_name)
		load_character(current_character)
	
	

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
	
	print("saving character...")
	
	ResourceSaver.save(res, fp)


func load_character(char : CharacterResource):
	current_character = char
	sprite.set_texture(char.texture)
	character_name = char.character_name
	calibrator.transform = char.calibrator_transform
	oil.transform = char.oil_transform
	charger.transform = char.charger_transform
	
	## create nuts
	#for i in char.nut_transforms:
		#nut = nut_scene.instantiate()
		#nut_controller.add_child(nut)
		#nut.transform = i
