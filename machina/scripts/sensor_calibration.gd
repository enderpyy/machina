class_name SensorCalibration extends ZoomInterface

@onready var animator = $AnimationPlayer
@onready var label = $Label2
@onready var center_sprite = $Sprite2D

var target_scene = load("res://scenes/target.tscn")

signal result
var spawn_size : Vector2

var calibrated := false

func _ready() -> void:
	super()
	spawn_size = spawn.shape.get_rect().size
	animator.play("blink_red")

var playing := false
func play( n := 5):
	if playing != true:
		playing = true
		var score := 0.0
		
		var initial_modulation : Color = center_sprite.modulate
		
		for i in range(n):
			var t : Target = target_scene.instantiate()
			center_sprite.add_child(t)
			var spawn_location = Vector2()
			spawn_location.x = randi_range(spawn.position.x - spawn_size.x/2, spawn.position.x + spawn_size.x/2)
			spawn_location.y = randi_range(spawn.position.y - spawn_size.y/2, spawn.position.y + spawn_size.y/2)
			t.position = spawn_location
			
			var result = await t.result
			if result == 1:
				var r = center_sprite.modulate.r + (1.0 - initial_modulation.r)/n
				var b = center_sprite.modulate.b + (1.0 - initial_modulation.b)/n
				var g = center_sprite.modulate.g + (1.0 - initial_modulation.g)/n
				change_color_to(r, g, b)
			
			score += result
			t.queue_free()
		
		change_color_to_hex("71e88c", 0.75)
		animator.play("game_success")
		
		print("your score was" + str (score))
		
		label.text = str(snapped(score/float(n), 0.01)) + "% accuracy"
		await animator.animation_finished
		calibrated = true
		
		playing = false
		await zoom_out()
		
		result.emit( score / float(n) )

func zoom_in():
	if playing != true:
		super()
		if calibrated == false:
			animator.stop()
			center_sprite.modulate.a = 1
			$CALIBRATE.visible = false
			#$Sprite2D.visible = false
			animator.play("zoom_in")

var can_zoom_out := true
func zoom_out():
	if playing != true and can_zoom_out == true:
		super()
		if calibrated == false:
			animator.play_backwards("zoom_in")
			await animator.animation_finished

func change_color_to(r : float, g : float, b : float, duration := 0.1):
	var tween = create_tween().set_parallel(true)
	
	tween.tween_property(center_sprite, "modulate:r", r, duration)
	tween.tween_property(center_sprite, "modulate:g", g, duration)
	tween.tween_property(center_sprite, "modulate:b", b, duration)

func change_color_to_hex(hex : String, duration := 0.1):
	var tween = create_tween().set_parallel(true)
	var color = Color(hex)
	
	tween.tween_property(center_sprite, "modulate:r", color.r, duration)
	tween.tween_property(center_sprite, "modulate:g", color.g, duration)
	tween.tween_property(center_sprite, "modulate:b", color.b, duration)


func _on_start_button_up() -> void:
	await get_tree().process_frame
	playing = true
	zoom_in()
	animator.play("start")
	await animator.animation_finished
	playing = false
	play()
