extends Node

signal reputation_changed(new_reputation)
signal time_changed(hours)

var reputation := 0 setget _set_reputation

# Number of orders that can be given next time
var orders := 5

# Time expressed in hours
var time := 6.0 setget _set_time


func reset():
	orders = 5


func _set_reputation(value:int)->void:
	reputation = value
	emit_signal("reputation_changed", value)


func _set_time(value:float)->void:
	time = value
	emit_signal("time_changed", time)
