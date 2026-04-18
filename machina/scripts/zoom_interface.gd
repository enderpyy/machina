class_name ZoomInterface extends Area2D


@onready
var background : Sprite2D = $Background
@onready
var spawn : CollisionShape2D = $"Spawn Area"

var initial_scale : Vector2 #updated before zoom in
var initial_position : Vector2 #updated before zoom in

func _ready() -> void:
	initial_scale = self.scale
	initial_position = self.position

var zoom_id = 0

#zoom to target position, at target scale, with lerp value
func zoom(target_position : Vector2, target_scale : Vector2, speed : float = 0.05):
	zoom_id += 1
	var id = zoom_id
	while abs(position - target_position) > Vector2(0.1, 0.1) or abs(scale - target_scale) > Vector2(0.01, 0.01):
		if id != zoom_id:
			return
		
		self.position = lerp(position, target_position, speed)
		self.scale = lerp(scale, target_scale, speed)
		await get_tree().process_frame


func zoom_in():
	zoom(Vector2(960, 540), Vector2(1,1))

func zoom_out():
	zoom(initial_position, initial_scale)

var zoomed := false
func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("left_click"):
		if zoomed == false and globals.zoomed == false:
			zoom_in()
			zoomed = true
			globals.zoomed =true
		elif zoomed == true:
			zoomed = false
			globals.zoomed = false
			zoom_out()
