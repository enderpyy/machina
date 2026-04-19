class_name SensorCalibration extends ZoomInterface



var target_scene = load("res://scenes/target.tscn")

signal result
var spawn_size : Vector2

func _ready() -> void:
	super()
	spawn_size = spawn.shape.get_rect().size

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
