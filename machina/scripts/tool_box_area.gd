class_name ToolboxArea extends Area2D

func _on_area_entered(area: Area2D) -> void:
	if area is BoltDetector:
		area.get_parent().reparent(self)
		area.get_parent().enter_toolbox(true)

func _on_area_exited(area: Area2D) -> void:
	if area is BoltDetector:
		area.get_parent().reparent(get_parent().get_parent().get_parent().get_parent())
		area.get_parent().enter_toolbox(false)
