extends Node2D

func _ready() -> void:
	for child : Screw in get_children().filter(func (child) : child is Screw):
		pass#connect(child.unscrewed, )
