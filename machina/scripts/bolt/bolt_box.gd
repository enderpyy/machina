extends Area2D

@export
var bolt_type : BoltResource

func accept_bolt(bolt):
	if bolt.bolt_name == bolt_type.bolt_name:
		bolt.queue_free()
