class_name WireConnector extends Area2D

func _on_body_entered(body: Node2D) -> void:
	#9print("connectin")
	if body is WireEnd:
		#print("connectin")
		body.connect_to(self)
