class_name ToolboxArea extends Area2D

func _on_area_entered(area: Area2D) -> void:
	if area is BoltDetector:
		print("body in")

func _on_area_exited(area: Area2D) -> void:
	if area is BoltDetector:
		print("body out")
