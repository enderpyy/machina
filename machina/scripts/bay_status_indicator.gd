class_name BayStatusIndicator extends Node2D

@onready var label = $scale/Label
var timer_node:Timer = null
func _ready():
	pass

func blink_red():
	$RedScreenEffect.show()
	$AnimationPlayer.play("blink_red")

func stop_blink_red():
	$AnimationPlayer.stop()
	$RedScreenEffect.hide()
	label.hide()
	timer_node = null

func robot_appear():
	$RobotIndicator.show()

func robot_dissapear():
	$RobotIndicator.hide()

@onready var animator = $AnimationPlayer
func low_time_left(_timer_node):
	timer_node = _timer_node
	$RedScreenEffect.show()	
	$AnimationPlayer.stop()
	$AnimationPlayer.play('bouta_bust', -1, 5)

func set_low_time_left_text(): # called by 
	label.show()
	label.text = str(int(timer_node.time_left+1))

func hide_text():
	label.hide()
