class_name City
extends Node2D
tool

signal pressed

export var city_name : String = "UNNAMED" setget _set_city_name
export var population : int = 0

func is_on_screen()->bool:
	return $VisibilityNotifier2D.is_on_screen()


func _set_city_name(value:String)->void:
	city_name = value
	$Label.text = value


func _on_Area2D_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed:
		emit_signal("pressed")
