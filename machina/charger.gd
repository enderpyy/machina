extends Node2D

@onready var pump_bar = $"Info/Pump Bar"
@onready var charge_bar = $"Info/Charge Bar"
@onready var cord_head = $"Cord Head"

var connected_character : Character

func _physics_process(delta: float) -> void:
	pump_bar.decay(delta)
	if pump_bar.get_charge() > 0 and cord_head.connected and connected_character:
		connected_character.charge_up(delta)
		print(connected_character.charge)
		charge_bar.update_bar_percentage(connected_character.charge)


func _on_pump_handle_down(f : float) -> void:
	if cord_head.connected:
		#connected_character.charge += f
		pump_bar.charge(f)

@onready var animator = $Animator
@onready var audio = $AudioStreamPlayer2D

@export var connect_sfx : AudioStreamWAV
@export var disconnect_sfx : AudioStreamWAV

func _on_cord_head_con(c: Character) -> void:
	connected_character = c
	if c != null:
		animator.play("connect")
		audio.stream = connect_sfx
		audio.play()
	else:
		animator.play_backwards("connect")
		audio.stream = disconnect_sfx
		audio.play()
