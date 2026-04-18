extends Node2D

var level := 0

@onready var root = get_parent()
@onready var announcer: Announcer = root.announcer

@onready var bays = [$'Repair Bay 5']

func _start_level(current_level):
	level = current_level
	
	match level:
		1:  
			await get_tree().create_timer(1).timeout
			
			announcer.announce("now take a dump for me on camera", 1.5, false)
			await announcer.finished
			await get_tree().create_timer(1).timeout
			announcer.announce("faster!", 1, true)
			# code for level 1
			
		2: pass
