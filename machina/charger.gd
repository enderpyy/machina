extends Node2D

@onready var pump_bar = $"Info/Pump Bar"
@onready var charge_bar = $"Info/Charge Bar"
@onready var cord_head = $"Cord Head"

func _physics_process(delta: float) -> void:
	pump_bar.decay(delta)
	if pump_bar.get_charge() > 0 and cord_head.connected:
		charge_bar.charge(delta)


func _on_pump_handle_down(f : float) -> void:
	if cord_head.connected:
		pump_bar.charge(f)

@onready var animator = $Animator
@onready var audio = $AudioStreamPlayer2D

@export var connect_sfx : AudioStreamWAV
@export var disconnect_sfx : AudioStreamWAV

func _on_cord_head_con(b: bool) -> void:
	if b:
		animator.play("connect")
		audio.stream = connect_sfx
		audio.play()
	else:
		animator.play_backwards("connect")
		audio.stream = disconnect_sfx
		audio.play()
