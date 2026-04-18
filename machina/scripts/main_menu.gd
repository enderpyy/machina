class_name MainMenu
extends Node2D

@onready var anim := $AnimationPlayer
@onready var start_button := $ButtonArea
@onready var main_theme := $"Main Theme"

signal game_start
signal game_pause
var on_screen := true

func _input(event):
	if event.is_action_pressed('esc'):
		game_pause.emit()
		fade_in()

func _on_start_pressed() -> void:
	fade_out()
	game_start.emit()

func fade_out():
	if on_screen == true:
		on_screen = false
		start_button.sensing = false
		var play_time = 0.8
		anim.play('fade_out', -1, 1/play_time)
		await anim.animation_finished

func fade_in():
	if on_screen == false:
		on_screen = true
		var play_time = 0.8
		anim.play('fade_out', -1, -1/play_time, true)
		await anim.animation_finished
		start_button.sensing = true
