extends Timer

@export var mute_audio := false


func _on_timeout() -> void:
	if not mute_audio:
		get_parent().play()
