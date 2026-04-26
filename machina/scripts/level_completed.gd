extends Node2D

var win := 'You were not fired today...'
var loss:= 'Your connection with E301 was terminated.'
var won_the_whole_game := 'Thank you for playing!'

signal done
@onready var label := $text
@onready var try_again := $try_again
@onready var anim := $AnimationPlayer
func play(completed, won_the_game):
	prints(completed, won_the_game)
	var text = win if completed else loss
	if won_the_game == true: text = won_the_whole_game
	#print(text)
	label.text = ''
	label.show()
	show()
	modulate.a = 1.0
	
	for c in text:
		label.text += c
		#print(label.text)
		await get_tree().create_timer(0.05).timeout
	
	await get_tree().create_timer(1.5)
	
	if won_the_game:
		Signals.announce_text.emit('besties 4 life', 2.0, false, false)
		$credits.show()
		await Signals.announce_end # it never comes. this is purposeful
	elif completed:
		Signals.announce_text.emit('good shit', 2.0, false, false)
		await get_tree().create_timer(3).timeout
		anim.play('fade_out')
		print('fading')
		await anim.animation_finished
		print('anim finished')
	else:
		Signals.announce_text.emit('ya been fired', 2.0, false, false)
		try_again.show()
		try_again.input_pickable = true
		await try_again.pressed
		try_again.input_pickable = false
		try_again.hide()
		anim.play('fade_out')
		await anim.animation_finished
	done.emit()
