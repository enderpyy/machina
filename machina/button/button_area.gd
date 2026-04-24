extends Area2D
signal pressed
signal released

var button_down := false
var sensing := true

func _on_inputt_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if not sensing:
		return
	if event.is_action_pressed('left_click') and button_down == false:
		#printt(self, event)
		button_down = true
		pressed.emit()

func _input(event: InputEvent) -> void:
	if event.has_meta("is_virtual"):
		pass
		#print(self, event)
	if event.is_action_released("left_click") and button_down == true:
		button_down = false
		released.emit()
