extends Sprite
class_name CityIcon

const _ASSET_PATTERN := "res://assets/Images/city_%s%s.png"

const _SMALL_CITY_IMAGE := preload("res://assets/Images/city_small.png")
const _MEDIUM_CITY_IMAGE := preload("res://assets/Images/city_medium.png")
const _LARGE_CITY_IMAGE := preload("res://assets/Images/city_large.png")
const _SMALL_CITY_RAIDED_IMAGE := preload("res://assets/Images/city_small_raided.png")

enum Size { SMALL, MEDIUM, LARGE }

export var size = Size.SMALL setget _set_size
export var raided := false setget _set_raided


func _set_size(value)->void:
	size = value
	texture = _lookup_image()


func _set_raided(value)->void:
	raided = value
	texture = _lookup_image()


func _lookup_image()->Texture:
	var size_string : String
	match size:
		Size.SMALL:
			size_string = "small"
		Size.MEDIUM:
			size_string = "medium"
		Size.LARGE:
			size_string = "large"
	var asset_path := _ASSET_PATTERN % [size_string, "_raided" if raided else ""]
	return load(asset_path) as Texture
