class_name Handle extends Area2D

@export var minimum_height : int
@export var maximum_height : int

@onready var audio = $AudioStreamPlayer2D
var pump = preload("res://audio/sfx/charger/pump.wav")

signal down

var previous_position
var following := false
var going_down := false
func _physics_process(delta: float) -> void:
	var mp = get_parent().get_local_mouse_position()
	if following:
		previous_position = self.position
		self.position.y = mp.y - mouse_offset.y
		if self.position.y > maximum_height:
			self.position.y = maximum_height
		elif self.position.y < minimum_height:
			self.position.y = minimum_height
		if previous_position.y < self.position.y and going_down == false:
			down.emit((self.position.y - previous_position.y)/(maximum_height-minimum_height))
			going_down = true
			audio.play()
		elif previous_position.y <= self.position.y and going_down == true:
			down.emit((self.position.y - previous_position.y)/(maximum_height-minimum_height))
		else:
			if going_down == true:
				going_down = false
	else:
		pass # if charge 

var mouse_offset
func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if Input.is_action_just_pressed("left_click") and following == false:
		print("clicked?")
		following = true
		mouse_offset = get_local_mouse_position()

func _input(event: InputEvent) -> void:
	if Input.is_action_just_released("left_click") and following == true:
		following = false
