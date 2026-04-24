class_name DialogueBox extends Node2D
'''
If you want the dialogue to close after the last sentence, append an empty string to the end of the array
'''


@onready var label = $scale/text
@onready var anim: AnimationPlayer  = $AnimationPlayer
@onready var continue_button := $continue_button
@onready var button := $ButtonArea

signal closed

func _ready():
	hide()

func say(text, t_char := 0.01, appear_anim:=true):
	label.text = ''
	continue_button.hide()
	if appear_anim:
		anim.play('appear')
		await anim.animation_finished
	anim.get_animation("bounce_on_it").loop_mode = Animation.LOOP_LINEAR
	anim.play('bounce_on_it')
	for c in text:
		label.text += c
		await get_tree().create_timer(t_char).timeout
	anim.get_animation("bounce_on_it").loop_mode = Animation.LOOP_NONE
	await anim.animation_finished # getting caught here for no reason!


func says(i_aint_reading_all_that: Array, t_char := 0.01):
	if not i_aint_reading_all_that:
		return
	var i = len(i_aint_reading_all_that)
	var on_first_sentence = true
	for sentence : String in i_aint_reading_all_that:
		assert(sentence is String, 'put a string in bozo')
		if sentence == '':
			anim.play_backwards("appear") # dissapear
			await anim.animation_finished
			hide()
			closed.emit()
			return
		elif sentence.begins_with("A:"):
			on_first_sentence = true
			Signals.announce_text.emit(sentence.substr(2), 5.0, false, true)
			anim.play_backwards("appear")
			await anim.animation_finished
			hide()
			await Signals.announce_end
			print("received announcement")
		else:
			print("saying next sentence")
			i -= 1
			await say(sentence, t_char, on_first_sentence)
			on_first_sentence = false
			if i > 0:
				anim.play('blink_continue_button', -1, 2)
				await button.pressed
				anim.stop()

## testing
#func _ready() -> void:
	#hide()
	#says(['obama, balls, sussy balls... dont mess with dicky dan...', 'unless youre tryina meet dicky frank...', 'and youre not tryina meet dicky frank.', ''])
