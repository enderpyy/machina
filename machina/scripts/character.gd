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
@onready var charger = $charger

@onready
var sprite : Sprite2D = $"Main Sprite"

func init(res : CharacterResource) -> void:
	current_character = res

func _ready() -> void:
	if save_to_file:
		save_character()
		return
	
	if current_character != null:
		load_character(current_character)

func save_character():
	var fp := "res://objects/characters/" + character_name + ".tres"
	var res : CharacterResource 
	if FileAccess.file_exists(fp):
		res = load(fp)
	else:
		res = CharacterResource.new()
	
	res.set_character_name(character_name)
	res.set_sprite(sprite.texture)
	
	calibrator_position = calibrator.position
	res.set_calibrator_position(calibrator_position)
	for child in nuts.get_children():
		nut_positions.append(child.position)
	res.set_nut_positions(nut_positions)
	oil_position = oil.position
	res.set_oil_position(oil_position)
	charger_position = charger.position
	res.set_charger_position(charger_position)
	
	ResourceSaver.save(res, fp)

func load_character(char):
	
	calibrator.position = char.calibrator_position
	#set nut positions here
	oil.position = char.oil_position
	charger.position = char.charger_position
