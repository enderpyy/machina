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

@onready
var sprite : Sprite2D = $"Main Sprite"

func _ready() -> void:
	print("ready")
	if save_to_file:
		print("saving to file?")
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
	
	res.set_calibrator_position(make_position_resource(calibrator))
	var nut_positions_resource : Array[Transform2D] = []
	for child in nuts.get_children():
		nut_positions_resource.append(make_position_resource(child))
	res.set_nut_positions(nut_positions_resource)
	res.set_charger_position(make_position_resource(charger))
	res.set_oil_position(make_position_resource(oil))
	
	
	print(res.get_charger_position())
	
	print("saving character...")
	
	ResourceSaver.save(res, fp)

func load_character(char : CharacterResource):
	current_character = char
	sprite.set_texture(char.get_sprite())
	character_name = char.get_character_name()
	set_node_position(calibrator, char.get_calibrator_position())
	#set nut positions here
	set_node_position(oil, char.get_oil_position())
	set_node_position(charger, char.get_charger_position())

func set_node_position(node : Node2D, res : Transform2D):
	#print(current_character.character_name)
	#print(current_character.calibrator_position)
	
	node.position = res.get_origin()
	node.scale = res.get_scale()
	node.rotation = res.get_rotation()

func make_position_resource(node: Node2D) -> Transform2D:
	var r : Transform2D
	r = node.transform
	return r
