extends ZoomInterface

@onready var wires_game = $"Wires Game"
var status_fixed := true
func set_children_disabled(b : bool):
	super(b)
	
	print("disabling child", str(b))
	for child in get_children():
		disable_children(child, b)

func disable_children(child : Node2D, b: bool):
	if child is CollisionObject2D:
		child.input_pickable = !b
	for c in child.get_children():
		if c is Label: return
		disable_children(c, b)

var game_finished := false

func zoom_in():
	super()
	if !game_finished:
		can_zoom = false

func zoom_out():
	if game_finished:
		super()

func _on_wires_game_game_finished() -> void:
	print("ALL DONE WQIT THTE WIRES! ")
	$Polygon2D/Label.show()
	game_finished = true
	can_zoom = true
	status_fixed = true
