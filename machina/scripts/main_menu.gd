extends Node2D

@onready var anim := $AnimationPlayer
@onready var button := $ButtonArea

signal game_start
signal game_paused

func _ready():
	await button.released
	fade_out()

func fade_out():
	var play_time = 0.8
	anim.play('fade_out', -1, 1/play_time)
	game_start.emit()
	await anim.animation_finished

func fade_in():
	var play_time = 0.8
	anim.play('fade_out', -1, 1/play_time)
	game_paused.emit()
	await anim.animation_finished
