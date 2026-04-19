class_name BayStatusIndicator extends Node2D

func _ready():
	pass

func blink_red():
	$RedScreenEffect.show()
	$AnimationPlayer.play("blink_red")

func stop_blink_red():
	$RedScreenEffect.hide()

func robot_appear():
	$RobotIndicator.show()

func robot_dissapear():
	$RobotIndicator.hide()
