class_name DialogueBox extends Node2D
'''
If you want the dialogue to close after the last sentence, append an empty string to the end of the array
'''


@onready var label = $scale/text
@onready var anim: AnimationPlayer  = $AnimationPlayer
@onready var continue_button := $continue_button
@onready var button := $ButtonArea

func _ready():
	hide()

func say(text, t_char := 0.01, appear_anim:=true):
	label.text = ''
	show()
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
	await anim.animation_finished
	

func says(i_aint_reading_all_that: Array[String], t_char := 0.01):
	print(i_aint_reading_all_that)
	var i = len(i_aint_reading_all_that)
	var on_first_sentence = true
	for sentence in i_aint_reading_all_that:
		if sentence == '':
			anim.play("appear", -1, -1, true)
			await anim.animation_finished
			hide()
			return
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
