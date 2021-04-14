extends Control

var city:City setget _set_city

onready var _city_name : Label = $VBoxContainer/CityName
onready var _population : Label = $VBoxContainer/Population

func _set_city(value:City)->void:
	assert(value!=null)
	city = value
	_city_name.text = city.name
	_population.text = "Population: %d" % city.population
