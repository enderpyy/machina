class_name BoltResource extends Resource

@export
var bolt_name : String
func set_bolt_name(n : String):
	bolt_name = n
func get_bolt_name() -> String:
	return bolt_name

@export
var sprite : Texture2D
func set_sprite(s : Texture2D):
	sprite = s
func get_sprite() -> Texture2D:
	return sprite

@export
var box_sprite : Texture2D
