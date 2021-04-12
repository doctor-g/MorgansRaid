extends Sprite
class_name CityIcon


const _SMALL_CITY_IMAGE := preload("res://assets/Images/city_small.png")
const _MEDIUM_CITY_IMAGE := preload("res://assets/Images/city_medium.png")
const _LARGE_CITY_IMAGE := preload("res://assets/Images/city_large.png")

enum Size { SMALL, MEDIUM, LARGE }

export var size = Size.SMALL setget _set_size

func _set_size(new_size)->void:
	size = new_size
	match new_size:
		Size.SMALL:
			texture = _SMALL_CITY_IMAGE
		Size.MEDIUM:
			texture = _MEDIUM_CITY_IMAGE
		Size.LARGE:
			texture = _LARGE_CITY_IMAGE

