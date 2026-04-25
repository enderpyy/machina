class_name ChargerPort extends Area2D

var status_fixed := true

func _on_body_entered(body: Node2D) -> void:
	if body is CordHead:
		pass#body.connect_to(self)

func get_character():
	return get_parent()
