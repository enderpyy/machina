class_name OldBoltSocket extends Node2D

@onready var bolt = $Bolt
@onready var joint = $PinJoint2D
@onready var axis = $Joint
@onready var panel_joint = $PinJoint2D2

signal unscrewed

@export var panel : RigidBody2D

func _ready() -> void:
	await get_tree().create_timer(0.1).timeout
	connect_bolt(bolt)



func connect_to_panel(b : bool):
	if b:
		print("connecting to panel")
		panel_joint.node_a = panel.get_path()
		
	else:
		panel_joint.node_a = axis.get_path()


func _on_bolt_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("left_click"):
		#joint.disabled = true
		disconnect_bolt(bolt)
		
		#unscrewed.emit()
		#self.queue_free()

func connect_bolt(b : Bolt):
	print('connecting bolt to spot, ', b)
	if not b: return
	bolt=b
	b.input_event.connect(_on_bolt_input_event)
	b.global_position = joint.global_position
	
	b.connected = true
	b.reparent(self, true)
	#await get_tree().process_frame
	play_sound(drill_in_sfx)
	bolt.apply_torque_impulse(5000)
	joint.set_deferred("node_a", b.get_path())
	await get_tree().create_timer(0.5).timeout
	if not bolt: return
	bolt.angular_velocity = 0

var disconnecting = false
func disconnect_bolt(b: Bolt):
	if !disconnecting:
		disconnecting = true
		bolt.apply_torque_impulse(5000)
		play_sound(drill_out_sfx)
		await get_tree().create_timer(0.5).timeout
		joint.node_a = axis.get_path()
		joint.set_deferred("node_a", axis.get_path())
		bolt.pop_bolt()
		bolt = null
		b.input_event.disconnect(_on_bolt_input_event)
		b.connected = false
		b.reparent(get_tree().get_root(), true)
		disconnecting = false


@onready var audio = $AudioStreamPlayer2D
var drill_in_sfx = preload("res://audio/sfx/drill_tighten.wav")
var drill_out_sfx = preload("res://audio/sfx/drill_loosen.wav")
func play_sound(sound : AudioStreamWAV):
	audio.stream = sound
	audio.play()



func _on_bolt_detector_area_entered(area: Area2D) -> void:
	if bolt == null:
		#print(globals.nut)
		if globals.nut != null:
			connect_bolt(globals.nut)
			globals.nut.follow_mouse(false)
			globals.nut = null
