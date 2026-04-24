extends Node2D

@onready var panel = $Panel

func _ready() -> void:
	get_parent().zoomed_in.connect(connect_screws)
	for child : Screw in get_children().filter(func (child) : child is Screw):
		pass#connect(child.unscrewed, )

func connect_screws():
	await get_tree().create_timer(1).timeout
	print("cpnnnnennenene")
	panel.freeze = false
	for child in get_children():
		if child is Screw:
			print("screw")
			child.connect_to_panel(true)
