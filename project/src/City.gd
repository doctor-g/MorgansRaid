class_name City
extends Node2D
tool

signal pressed

const _SMALL_THRESHOLD := 1499
const _MEDIUM_THRESHOLD := 4999

export var city_name : String = "UNNAMED" setget _set_city_name
export var population : int = 0 setget _set_population


func is_on_screen()->bool:
	return $VisibilityNotifier2D.is_on_screen()


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
