class_name BoltSocket extends Node2D

@onready
var animator = $Bolt/AnimationPlayer
@onready
var pivot = $Pivot
@onready
var placeholder = $Pivot/Placeholder
@export 
var bolt : RigidBody2D

signal remove

func _ready() -> void:
	pass

func fade():
	animator.play("fade")
	await animator.animation_finished
	pass

func attach(body = placeholder): #default detaches
	pivot.node_a = body.get_path()

func can_rotate(b : bool):
	bolt.set_deferred("lock_rotation", !b)

func _on_wrench_detector_area_entered(area: Area2D) -> void:
	if area is BoltArea:
		can_rotate(true)
		print(bolt.lock_rotation)

func _on_wrench_detector_area_exited(area: Area2D) -> void:
	if area is BoltArea:
		can_rotate(false)

func accept_bolt(b : RigidBody2D):
	if bolt == null:
		attach(b)

func remove_bolt():
	if bolt != null:
		attach()
