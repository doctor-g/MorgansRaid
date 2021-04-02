extends Node2D

signal pressed

export var city_name : String setget _set_city_name

func _set_city_name(value:String):
	assert(value!=null)
	city_name = value
	$Label.text = city_name


func _on_Arrow_pressed():
	emit_signal("pressed")
