class_name CharacterResource extends Resource

@export
var character_name : String
@export
var sprite : Texture2D

#data
var calibrator_position : Vector2
var nut_positions : Array[Vector2]
var oil_position : Vector2
var charger_position : Vector2

func set_character_name(n : String):
	character_name = n
func set_sprite(s : Texture2D):
	sprite = s
func set_calibrator_position(pos : Vector2):
	calibrator_position = pos
func set_nut_positions(pos : Array[Vector2]):
	nut_positions = pos
func set_oil_position(pos : Vector2):
	oil_position = pos
func set_charger_position(pos : Vector2):
	charger_position = pos
