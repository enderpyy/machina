class_name RepairBay extends Node2D

@export var status_indicator :BayStatusIndicator
var repair_bay_number : int
var current_character = null
var charger = preload("res://scenes/charger.tscn")
var charger_pos = Vector2(1492, 821)
@onready var slider := $slider
var timing := false
@onready var timer := $Timer

@onready var label = $bg_pixelator/scale/Label
func _ready():
	$Label.text = name
	var parent : FNAF_base
	await get_tree().process_frame
	parent = get_parent()
	await parent.anim.animation_finished
	var c = charger.instantiate()
	add_child(c)
	c.position = charger_pos
	#$bg_pixelator
	
func stop_status_indicator():
	status_indicator.stop_blink_red()

func start_countdown(t:float): # called by character
	print('COUNT DOWN!')
	slider.show()
	slider.percent = 1.0
	timing = true
	timer.wait_time = t
	timer.start()
	status_indicator.low_time_left(timer)

var status_alarm_high := false
func _process(delta: float) -> void:
	if timing:
		slider.percent = float(timer.time_left) / float(timer.wait_time)
		status_indicator.set_low_time_left_text()
		if status_alarm_high==false and timer.time_left < 10.0:
			status_alarm_high = true
			
func _on_timer_timeout() -> void:
	timing = false
	status_alarm_high = false
	if current_character:
		current_character.explode()

func diffuse_bomb(): # called by character
	timer.stop()
	status_alarm_high = false
	timing = false
	slider.percent = 0.0
