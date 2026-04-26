class_name CordHead extends RigidBody2D

var following := false
var radius = 400
var connected := false

signal con

func _physics_process(delta: float) -> void:
	#print(self.freeze)
	#print(following)
	if following:
		#print("not happening")
		#print("following")
		var v = (get_global_mouse_position()-self.global_position)*10 #.limit_length(max_speed)
		#print(get_parent().get_local_mouse_position().length())
		#print(position.length()`)
		if position.length() > radius:
			#print("limiting")
			v = v.limit_length(800)
			#print(v.length())
		self.linear_velocity = v#.limit_length(800)
		#print("lin v: " + str(linear_velocity.length()))

func set_following(b : bool):
	following = b
	set_deferred("freeze", !b)
	
	if freeze:
		linear_velocity = Vector2.ZERO
		angular_velocity = 0
		self.modulate = Color(1.3, 1.3, 1.3)
	else:
		self.modulate = Color(1.0, 1.0, 1.0)

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("left_click"):
		if following:
			set_following(false)
		else:
			set_following(true)
			if connected:
				print('disconnectning')
				disconnect_head()

var connection_speed = 500
func connect_head(port : ChargerPort):

	following = false
	
	await goto_global_position(port.global_position)

	set_following(false)
	print("hgfjhgfjhgfjhgfjhgfjhgfjhgf")
	con.emit(port.get_character()) # 
	
	connected = true

func disconnect_head():
	con.emit(null)
	connected = false


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area is ChargerPort:
		connect_head(area)

func goto_global_position(pos: Vector2):
	while (self.global_position - pos).length() > 10:
		var direction = self.global_position.direction_to(pos)
		self.linear_velocity = direction*connection_speed
		await get_tree().process_frame

func goto_position(pos: Vector2):
	while (self.position - pos).length() > 10:
		var direction = self.position.direction_to(pos)
		self.linear_velocity = direction*connection_speed
		await get_tree().process_frame
