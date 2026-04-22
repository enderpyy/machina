class_name ChargerPort extends Area2D



func _on_body_entered(body: Node2D) -> void:
	print("connect")
	if body is CordHead:
		pass#body.connect_to(self)
