class_name ChargerPort extends Area2D

var status_fixed := true
var pump
func _on_body_entered(body: Node2D) -> void:
	if body is CordHead:
		pump = body.get_parent()

func get_character():
	return get_parent()

func force_disconnect():
	#print(pump)
	if pump:
		pump.character_disconnected()
