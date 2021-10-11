class_name City
extends Node2D
tool

signal pressed

const _SMALL_THRESHOLD := 1499
const _MEDIUM_THRESHOLD := 4999

export var city_name : String = "UNNAMED" setget _set_city_name
export var population : int = 0 setget _set_population
export var raided := false setget _set_raided

var selectable := false setget _set_selectable

onready var _city_icon : CityIcon = $CityIcon
onready var _highlight := $Highlight
onready var _animation_player := $AnimationPlayer


func _ready():
	# See _set_raided() below.
	_city_icon.raided = raided


func _set_city_name(value:String)->void:
	city_name = value
	$Label.text = value


func _on_Area2D_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed:
		emit_signal("pressed")


func _set_population(value:int)->void:
	population = value
	if population <= _SMALL_THRESHOLD:
		$CityIcon.size = CityIcon.Size.SMALL
	elif population <= _MEDIUM_THRESHOLD:
		$CityIcon.size = CityIcon.Size.MEDIUM
	else:
		$CityIcon.size = CityIcon.Size.LARGE


func _set_selectable(value:bool)->void:
	selectable = value
	if selectable:
		_highlight.visible = true
		_animation_player.play("highlight")
	else:
		_highlight.visible = false
		_animation_player.stop()


func _set_raided(value:bool)->void:
	raided = value
	
	# This is a 'tool', so the _city_icon may not yet
	# be set. The initial case is covered in _ready().
	if _city_icon != null:
		_city_icon.raided = value
