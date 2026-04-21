class_name MainMenu
extends Node2D

@onready var anim := $AnimationPlayer
@onready var anim2 := $AnimationPlayer2
@onready var start_button := $ButtonArea
@onready var main_theme := $"Main Theme"
@onready var parent = get_parent()

var on_screen := false

func _ready():
	$TITLE.hide()
	await get_tree().create_timer(2.95).timeout
	$TITLE.show()
	on_screen = true

func _input(event):
	if event.is_action_pressed('esc'):
		parent.game_pause.emit()
		fade_in2()

func _on_start_pressed() -> void:
	fade_out2()
	parent.game_start.emit()

var settings_menu 
var settings_open := false
func _on_settings_button_pressed() -> void:
	var ddd_mode = true # 3d mode
	if ddd_mode:
		if !settings_open:
			anim2.play("how2play")
			settings_open = true
		else:
			anim2.play_backwards("how2play")
			settings_open = false
	else:
		if !settings_open:
			anim.play("settings")
			settings_open = true
		else:
			anim.play_backwards("settings")
			settings_open = false

func fade_out2():
	if on_screen == true:
		on_screen = false
		start_button.sensing = false
		anim2.play('start')
		await anim2.animation_finished
		$PAUSE_DARKEN.show()


func fade_in2():
	if on_screen == false:
		on_screen = true
		anim2.play_backwards('start')
		await anim2.animation_finished
		print('done fading in')
		start_button.sensing = true

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
