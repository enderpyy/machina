extends Node2D

@onready var pump_bar = $"Info/Pump Bar"
@onready var charge_bar = $"Info/Charge Bar"

func _physics_process(delta: float) -> void:
	pump_bar.decay(delta)
	if pump_bar.get_charge() > 0:
		charge_bar.charge(delta)


func _on_pump_handle_down(f : float) -> void:
	pump_bar.charge(f)

@onready var animator = $Animator

func _on_cord_head_con(b: bool) -> void:
	if b:
		animator.play("connect")
	else:
		animator.play_backwards("connect")
