extends Node2D

@onready var mouse := $mouse
@onready var resolution := get_viewport().get_visible_rect().size
@onready var center := resolution / 2


func _ready():
	Engine.max_fps = 60

	await $"Main Menu".game_start
	mouse.apply_mouse_slippery(150, 0.94)
	$FNAF_base.visible = true

func _process(delta: float) -> void:
	pass
