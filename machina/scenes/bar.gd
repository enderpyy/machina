extends Control

@export var charge_rate : float
@export var time : float = 10

@onready var tracker = $ColorRect3
@onready var bg = $ColorRect2

var maximum_length

func _ready():
	maximum_length = bg.size.x

func update_bar_percentage(f : float):
	tracker.size.x = clamp(maximum_length * f, 0, maximum_length)

func charge(f : float):
	tracker.size.x += maximum_length * f * charge_rate
	tracker.size.x = clamp(tracker.size.x, 0, maximum_length)

func get_charge() -> float:
	return tracker.size.x

func decay(delta) -> void:
	charge(-maximum_length/60/time*delta)
