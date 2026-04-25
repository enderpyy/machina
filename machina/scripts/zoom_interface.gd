class_name ZoomInterface extends Area2D

signal zoomed_in
signal zoomed_out

@onready
var background : Sprite2D = $Background
@onready
var spawn : CollisionShape2D = $"Spawn Area"

var can_zoom := true

var initial_scale : Vector2 #updated before zoom in
var initial_position : Vector2 #updated before zoom in
var initial_rotation : float
var initial_z : int

func _ready() -> void:
	initial_scale = self.scale
	initial_position = self.position
	initial_rotation = self.rotation_degrees
	initial_z = self.z_index
	
	print(initial_scale)
	print(initial_position)

var zoom_id = 0

#zoom to target position, at target scale, with lerp value
func zoom(target_position : Vector2, target_scale : Vector2, rot : float = 0.0, speed : float = 0.05):
	zoom_id += 1
	var id = zoom_id
	while abs(position - target_position) > Vector2(0.1, 0.1) or abs(scale - target_scale) > Vector2(0.01, 0.01):
		if id != zoom_id:
			return
		
		self.position = lerp(position, target_position, speed)
		self.scale = lerp(scale, target_scale, speed)
		scale_rb_children(self, lerp(scale, target_scale, speed))
		self.rotation_degrees = lerp(rotation_degrees, rot, speed)
		await get_tree().process_frame

func scale_rb_children(node: Node, v: Vector2):
	for child in node.get_children():
		if node is RigidBody2D:
			child.scale = v
		if child is Node2D:
			if child is RigidBody2D:
				scale_rb_children(child, v)
			else:
				scale_rb_children(child, v)
			

func set_children_disabled(b : bool):
	pass


func zoom_in():
	print("zoomed in")
	#print("can zoom " + str(can_zoom))
	if can_zoom:
		set_deferred("z_index", 10)
		zoom(Vector2(), Vector2(1,1))
		zoomed_in.emit()
		set_children_disabled(false)

func zoom_out():
	#print(" zoomed out")
	if can_zoom:
		set_children_disabled(true)
		zoom(initial_position, initial_scale, initial_rotation)
		zoomed_out.emit()
		set_deferred("z_index", initial_z)

var zoomed := false
func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("left_click"):
		if zoomed == false and get_parent().zoomed_in == false and can_zoom:
			zoom_in()
			zoomed = true
			get_parent().zoomed_in = true
		elif zoomed == true and can_zoom:
			zoomed = false
			get_parent().zoomed_in = false
			zoom_out()
