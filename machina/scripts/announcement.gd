class_name Announcer
extends Node2D

signal finished

@onready var text := $scaler/Text

var goto_y_position := -200 # lerps to this position as it changes
var offset := Vector2.ZERO
var _shake := false
	
func announce(message:String, duration:float, shake:bool):
	show()
	assert(len(message) < 33, str(len(message)) + " letters, check ya girth king - announcement.gd")
	text.text = message
	goto_y_position = 0 # y position that shows the message
	await get_tree().create_timer(0.2).timeout
	_shake = shake
	await get_tree().create_timer(duration).timeout
	goto_y_position = -200
	_shake = false
	await get_tree().create_timer(0.2).timeout
	hide()
	await get_tree().create_timer(1).timeout
	finished.emit()
	
func _process(_delta: float) -> void:
	position -= offset
	
	if position.y != goto_y_position:
		position.y = move_toward(position.y, goto_y_position, 10)
	if _shake:
		offset = Vector2(randi_range(-10, 10), randi_range(-10, 10))
	else:
		offset = Vector2.ZERO
	position += offset
