class_name ToolboxArea extends Area2D



func _on_body_entered(body: Node2D) -> void:
	if body is Bolt:
		body.in_toolkit = true




func _on_body_exited(body: Node2D) -> void:
	if body is Bolt:
		body.in_toolkit = false
