class_name Screw extends Node2D

@onready var screw = $"Screw Body"
@onready var joint = $PinJoint2D
@onready var axis = $Joint
@onready var panel_joint = $PinJoint2D2

signal unscrewed

@export var panel : RigidBody2D

func _ready() -> void:
	pass

func _on_screw_body_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("left_click"):
		#joint.disabled = true
		screw.apply_torque_impulse(1000000)
		await get_tree().create_timer(0.5).timeout
		var angle = -randf_range(45.0, 135.0)
		var direction = Vector2(cos(deg_to_rad(angle)), sin(deg_to_rad(angle)))
		joint.node_a = axis.get_path()
		if panel:
			connect_to_panel(false)
		screw.apply_force(direction * 20000)
		#print("clicked")
		await get_tree().create_timer(5).timeout
		#unscrewed.emit()
		#self.queue_free()

func connect_to_panel(b : bool):
	if b:
		print("connecting to panel")
		panel_joint.node_a = panel.get_path()
		
	else:
		panel_joint.node_a = axis.get_path()
