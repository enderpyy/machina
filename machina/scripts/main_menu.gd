extends Node2D

@onready var anim := $AnimationPlayer

signal game_start

func button_pressed(a):
	if a.mouse_down:
		fade_out()

func fade_out():
	var play_time = 0.2
	anim.play('fade_out', -1, 1/play_time)
	await anim.animation_finished
	game_start.emit()
	queue_free()
