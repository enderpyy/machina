class_name CharacterResource extends Resource

@export var character_name : String

@export var texture : Texture2D

@export var sprite_transform : Transform2D

@export var calibrator_transform : Transform2D

@export var bolt_transforms: Array[Transform2D]

@export var oil_transform: Transform2D

@export var charger_transform: Transform2D

@export var wires_transform: Transform2D

@export var enter_dialogue: Array[String]
@export var exit_dialogue: Array[String]

@export var explode_time:float = 30.0
@export var default_bolt_color: Color
@export var desired_bolt_color: Color

var games = ["nut", "calibrator", "oil", "charger"]

@export var problems : Dictionary = {
	"nut" : false,
	"calibrator" : false,
	"oil" : false,
	"charger" : false,
	"wires" : false
}

var transforms : Dictionary = {
	"nut" : bolt_transforms,
	"calibrator" : calibrator_transform,
	"oil" : oil_transform,
	"charger" : charger_transform,
	"wires" : wires_transform
}

@export var charge_rate := 10.0
