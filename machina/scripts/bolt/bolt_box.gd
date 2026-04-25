extends Area2D

@export
var bolt_type : BoltResource

@onready
var sprite = $"Box Sprite"

var bolt_scene = preload("res://scenes/bolt.tscn")
func _ready() -> void:
	sprite.texture = bolt_type.box_sprite

func accept_bolt(bolt):
	if bolt.bolt_name == bolt_type.bolt_name:
		bolt.queue_free()



#func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	#if event.is_action_pressed("left_click") and globals.nut == false:
		#globals.nut = true
		#var b = bolt_scene.instantiate()
		#get_parent().add_child(b)
		#b.position = get_global_mouse_position()
		#b.build(bolt_type)
		#b.follow_mouse(true)
		
