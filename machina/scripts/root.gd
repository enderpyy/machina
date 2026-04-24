extends Node2D

@onready var mouse := $mouse
@onready var menu = $"Main Menu"
@onready var resolution := get_viewport().get_visible_rect().size
@onready var center := resolution / 2
@onready var camera = $Camera2D
@onready var announcer = $Camera2D/Announcer

var FNAF_base_tscn = preload("res://scenes/fnaf_base.tscn")

func _ready():
	Engine.max_fps = 60
	$Camera2D/sky_spinner.play("spin_sky")
	await menu.game_start
	#mouse.apply_mouse_slippery(150, 0.94)
	var level: FNAF_base = FNAF_base_tscn.instantiate()
	level.scale = Vector2(0.001, 0.001)
	add_child(level)
	level.hide()
	level._start_level(1)
	while true:
		var i = await level.completed
		level = FNAF_base_tscn.instantiate() # reinstance level
		level.hide()
		level._start_level(1)

func _process(_delta: float) -> void:
	pass

func pause_game():
	menu.fade_in()
