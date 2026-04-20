extends CollisionPolygon2D
@export var copy :Polygon2D

func _ready():
	polygon = copy.polygon
	transform = copy.transform
