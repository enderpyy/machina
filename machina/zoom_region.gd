extends ZoomInterface

@onready var line_edit = $LineEdit
@onready var animator = $AnimationPlayer
@onready var hex_sprite = $Sprite2D2/Sprite2D2
@onready var button = $Button

func _ready() -> void:
	super()


func _on_line_edit_text_submitted(new_text: String) -> void:
	if !animator.is_playing():
		if is_valid_hex(new_text):
			hex_sprite.modulate = Color(new_text)
			animator.play("hex_load")
	else:
		pass
	

func is_valid_hex(text: String) -> bool:
	var regex = RegEx.new()
	regex.compile("^#?([0-9a-fA-F]{3,4}){1,2}$")
	return regex.search(text) != null

var bolt_scene = preload("res://scenes/bolt.tscn")
func _on_button_button_up() -> void:
	animator.play("print_hex")
	await animator.animation_finished
	for i in range(4):
		var b = bolt_scene.instantiate()
		get_parent().get_parent().add_child(b)
		b.global_position = hex_sprite.global_position
		b.pop_bolt()
		b.set_color(hex_sprite.modulate)
		hex_sprite.modulate.a = 0.0
		if i != 3:
			var tween = create_tween()
			tween.tween_property(hex_sprite, "modulate:a", 1.0, 1.0) 
			play_sound(ding_sfx)
			await get_tree().create_timer(1.1).timeout
			
		else:
			play_sound(ding_sfx)
			button.disabled = true

@onready var audio = $AudioStreamPlayer2D
var done_sfx = preload("res://audio/sfx/hex_done_1.wav")
var ding_sfx = preload("res://audio/sfx/bolt_ding.wav")
func play_sound(sound):
	audio.stream = sound
	audio.play()
