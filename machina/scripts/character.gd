class_name Character extends Node2D

@onready
var sprite : Sprite2D = $"Main Sprite"

func init(resource : CharacterResource):
	sprite.texture = resource.sprite
