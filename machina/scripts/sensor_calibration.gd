class_name SensorCalibration extends Area2D



var target_scene = load("res://scenes/target.tscn")

signal result

@onready
var background : Sprite2D = $Background
@onready
var spawn : CollisionShape2D = $"Spawn Area"
var spawn_size

var initial_scale : Vector2 #updated before zoom in
var initial_position : Vector2 #updated before zoom in

func _ready() -> void:
	spawn_size = spawn.shape.get_rect().size
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
	initial_scale = self.scale
	
	initial_position = self.position
	zoom(Vector2(960, 540), Vector2(1,1))

func zoom_out():
	zoom(initial_position, initial_scale)

func play( n := 5):
	var score := 0.0
	
	for i in range(n):
		var t : Target = target_scene.instantiate()
		self.add_child(t)
		var spawn_location = Vector2()
		spawn_location.x = randi_range(spawn.position.x - spawn_size.x/2, spawn.position.x + spawn_size.x/2)
		spawn_location.y = randi_range(spawn.position.y - spawn_size.y/2, spawn.position.y + spawn_size.y/2)
		t.position = spawn_location
		
		score += await t.result
		t.queue_free()
	
	print("your score was" + str (score))
	result.emit( score / float(n) )
