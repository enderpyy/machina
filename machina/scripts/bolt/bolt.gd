class_name Bolt extends RigidBody2D

signal dropped

var following = false

@onready var detector = $Detector
@onready var sprite = $Sprite
var bolt_name : String = ""

func init(bolt_type):
	sprite = bolt_type.get_sprite()
	bolt_name = bolt_type.get_bolt_name()

func _process(delta: float) -> void:
	if following:
		linear_velocity = (get_global_mouse_position() - position)*10

func build(type : BoltResource):
	print(sprite)
	sprite.texture = type.sprite
	name = type.bolt_name

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("left_click"):
		if following == false and globals.nut == false:
			globals.nut = true
			following = true

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click") and following == true:
		following = false
		globals.nut = false
		for area in detector.get_overlapping_areas():
			if area.has_method("accept_bolt"):
				area.accept_bolt(self)
