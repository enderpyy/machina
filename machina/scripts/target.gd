class_name Target extends Area2D

signal result
signal finished

var result_value: float = -1 # -1 = not assigned, 0 = failed, 1 = success

@export var timer : Timer # timer for length await click 

func _ready() -> void:
	result.emit(await go())

func _process(delta: float) -> void:
	self.scale *= 1.01

func go() -> float:
	timer.start()
	#print("timer start")
	await finished
	#print("result" + str (result_value))
	return result_value


func _input_event(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouse and event.is_pressed():
		if result_value == -1:
			result_value = 1.0
			timer.stop()
			finished.emit()

func _on_timer_timeout() -> void:
	if result_value == -1:
		result_value = 0.0
		#print("timer done")
		finished.emit()
