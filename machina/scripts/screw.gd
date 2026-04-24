class_name Screw extends Node2D

@onready var bolt = $Bolt
@onready var joint = $PinJoint2D
@onready var axis = $Joint
@onready var panel_joint = $PinJoint2D2

signal unscrewed

@export var panel : RigidBody2D

func _ready() -> void:
	await get_tree().create_timer(5).timeout
	#connect_bolt(bolt)



func connect_to_panel(b : bool):
	if b:
		print("connecting to panel")
		panel_joint.node_a = panel.get_path()
		
	else:
		panel_joint.node_a = axis.get_path()


func _on_bolt_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("left_click"):
		#joint.disabled = true
		bolt.apply_torque_impulse(1000000)
		play_sound(drill_out_sfx)
		await get_tree().create_timer(0.5).timeout
		var angle = -randf_range(45.0, 135.0)
		var direction = Vector2(cos(deg_to_rad(angle)), sin(deg_to_rad(angle)))
		joint.node_a = axis.get_path()
		if panel:
			connect_to_panel(false)
		bolt.apply_force(direction * 20000)
		#print("clicked")
		#disconnect_bolt(bolt)
		await get_tree().create_timer(5).timeout
		unscrewed.emit()
		self.queue_free()

func connect_bolt(b : Bolt):
	bolt=b
	b.input_event.connect(_on_bolt_input_event)
	b.position = joint.position
	joint.set_deferred("node_a", b.get_path())
	b.connected = true
	b.reparent(self)

func disconnect_bolt(b: Bolt):
	bolt = null
	b.input_event.disconnect(_on_bolt_input_event)
	joint.set_deferred("node_a", axis.get_path())
	b.connected = false
	b.reparent(get_tree().get_root())

@onready var audio = $AudioStreamPlayer2D
var drill_in_sfx = preload("res://audio/sfx/drill_tighten.wav")
var drill_out_sfx = preload("res://audio/sfx/drill_loosen.wav")
func play_sound(sound : AudioStreamWAV):
	audio.stream = sound
	audio.play()
