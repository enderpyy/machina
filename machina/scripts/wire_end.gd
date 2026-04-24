class_name WireEnd extends RigidBody2D

signal connected

var following := false
var connecting := false

func _process(delta: float) -> void:
	if following:
		linear_velocity = (get_global_mouse_position()-self.global_position)*10

func set_following(b : bool):
	following = b
	set_deferred("freeze", !b)

var connection_speed = 500
func connect_to(port : WireConnector):
	following = false
	connecting = true
	
	while (self.global_position - port.global_position).length() > 10:
		
		var direction = self.global_position.direction_to(port.global_position)
		#print(self.global_position)
		self.linear_velocity = direction*connection_speed
		await get_tree().process_frame
	
	self.linear_velocity = Vector2()
	self.global_position = port.global_position
	await get_tree().process_frame
	
	connected.emit(get_parent().modulate == port.modulate)
	connecting = false
	set_following(false)


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	#print("clicking?")
	if event.is_action_pressed("left_click") and following != true:
		set_following(true)
