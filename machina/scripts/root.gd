extends Node2D

@onready var mouse := $mouse
@onready var menu = $"Main Menu"
@onready var resolution := get_viewport().get_visible_rect().size
@onready var center := resolution / 2
@onready var camera = $Camera2D
@onready var announcer = $Camera2D/Announcer

var FNAF_base_tscn = preload("res://scenes/fnaf_base.tscn")

## ENDER WIDDER please set this value correctly
const final_day_level = 1 # game_won = true if (on_level >= final_day_level)

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
	var on_level = 1
	while true:
		var success = await level.completed
		var game_won = true if ((on_level >= final_day_level) and (success == true)) else false
		await $LevelCompleted.play(success, game_won)
		if game_won:
			return
		if success == true:
			on_level += 1
		level = FNAF_base_tscn.instantiate() # reinstance level
		level.visible = false
		level.process_mode = Node.PROCESS_MODE_PAUSABLE
		add_child(level)
		level._start_level(on_level)

func _process(_delta: float) -> void:
	pass

func pause_game():
	menu.fade_in()
	get_tree().paused = true
