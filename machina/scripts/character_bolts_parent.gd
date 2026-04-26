extends Node2D

var status_fixed := true
func _process(delta: float) -> void:
	var wantcolor = get_parent().desired_bolt_color
	status_fixed = true
	for i in get_children():
		if i.bolt:
			if i.bolt.modulate != wantcolor:
				status_fixed = false
		else:
			status_fixed = false
