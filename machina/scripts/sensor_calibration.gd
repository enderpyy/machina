class_name SensorCalibration extends Area2D

var screen_size : Vector2

var target_scene = load("res://scenes/target.tscn")

signal result

@onready
var background : Sprite2D = $Background
@onready
var spawn : CollisionShape2D = $"Spawn Area"
var spawn_size

var initial_scale : Vector2
var initial_position : Vector2

func _ready() -> void:
	screen_size = background.texture.get_size() * background.scale
	spawn_size = spawn.shape.get_rect().size
	
	zoom_in()

func zoom(target_position : Vector2, target_scale : Vector2, speed : float = 0.05):
	initial_scale = self.scale
	initial_position = self.position
	
	while abs(position - target_position) > Vector2(5, 5) or abs(scale - target_scale) > Vector2(0.05, 0.05):
		self.position = lerp(position, target_position, speed)
		self.scale = lerp(scale, target_scale, speed)
		await get_tree().process_frame


func zoom_in():
	zoom(Vector2(960, 540), Vector2(1,1))

func zoom_out():
	pass

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
