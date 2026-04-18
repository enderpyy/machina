extends Area2D
signal pressed
signal released

var button_down := false
var mouse_inside := false


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if mouse_inside:
		if event.is_action_pressed('left_click'):
			button_down = true
			pressed.emit()
		elif event.is_action_released("left_click"):
			button_down = false
			released.emit()
	
func _on_mouse_entered() -> void:
	mouse_inside = true
	
func _on_mouse_exited() -> void:
	if button_down:
		released.emit()
	mouse_inside = false
	button_down = false
	
