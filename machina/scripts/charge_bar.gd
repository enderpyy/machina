extends Control

@export var charge_rate : float
@export var time : float = 10

@export var starting_hue : Color
@export var ending_hue : Color

@onready var tracker = $ColorRect3
@onready var bg = $ColorRect2


var maximum_length

func _ready():
	maximum_length = bg.size.y

func update_bar_percentage(f : float):
	tracker.size.y = clamp(maximum_length * f, 0, maximum_length)

func charge(delta):
	#print("chargin")
	tracker.size.y += maximum_length * charge_rate * delta / 60
	
	#print()
	#print("b4 c: " + str(tracker.size.y))
	tracker.size.y = clamp(tracker.size.y, 0, maximum_length)
	if tracker.size.y < maximum_length:
		tracker.position.y -= maximum_length * charge_rate * delta / 60	
	#print("a4 c: " + str(tracker.size.y))
	
	tracker.color = starting_hue.lerp(ending_hue, get_charge()) 

func get_charge() -> float:
	return tracker.size.y/maximum_length
