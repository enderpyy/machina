class_name CharacterResource extends Resource

# Variables
## character_name - String
## sprite - Texture2D
## calibrator_position - Vector2
## nut_positions - Array[Vector2]
##oil_position - Vector2
##charger_position - Vector2

@export
var character_name : String
func set_character_name(n : String):
	character_name = n
func get_character_name() -> String:
	return character_name

@export
var sprite : Texture2D
func set_sprite(s : Texture2D):
	sprite = s
func get_sprite() -> Texture2D:
	return sprite


var calibrator_position : Transform2D
func set_calibrator_position(pos : Transform2D):
	calibrator_position = pos
func get_calibrator_position() -> Transform2D:
	return calibrator_position

var nut_positions : Array[Transform2D]
func set_nut_positions(pos : Array[Transform2D]):
	nut_positions = pos
func get_nut_positions() -> Array[Transform2D]:
	return nut_positions

var oil_position : Transform2D
func set_oil_position(pos : Transform2D):
	oil_position = pos
func get_oil_position() -> Transform2D:
	return oil_position

var charger_position : Transform2D
func set_charger_position(pos : Transform2D):
	charger_position = pos
func get_charger_position() -> Transform2D:
	return charger_position
