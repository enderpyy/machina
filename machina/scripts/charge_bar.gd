extends Control



@export var starting_hue : Color
@export var ending_hue : Color

@onready var tracker = $ColorRect3
@onready var bg = $ColorRect2


var maximum_length

func _ready():
	maximum_length = bg.size.y

func update_bar_percentage(f : float):
	tracker.size.y = clamp(maximum_length * f, 0, maximum_length)
	#print(maximum_length - tracker.size.y)
	tracker.position.y = maximum_length - tracker.size.y
	
	tracker.color = starting_hue.lerp(ending_hue, get_charge()) 

func get_charge() -> float:
	return tracker.size.y/maximum_length
