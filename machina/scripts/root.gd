extends Node2D

@onready var mouse := $mouse
@onready var menu = $"Main Menu"
@onready var resolution := get_viewport().get_visible_rect().size
@onready var center := resolution / 2

var FNAF_base = preload("res://scenes/fnaf_base.tscn")

func _ready():
	Engine.max_fps = 60

	await menu.game_start
	#mouse.apply_mouse_slippery(150, 0.94)
	var level_1 = FNAF_base.instantiate()
	add_child(level_1)
	level_1._start_level(1)

func _process(delta: float) -> void:
	pass

func pause_game():
	menu.fade_in()
	
