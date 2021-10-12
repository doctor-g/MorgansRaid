extends Node

signal reputation_changed(new_reputation)
signal time_changed(hours)
signal distance_changed(distance_to_ohio)

var reputation := 0 setget _set_reputation

# Number of orders that can be given next time
var orders := 5

# Time expressed in hours
var time := 6.0 setget _set_time

# Distance in screen units to Ohio (Harrison)
var distance_to_ohio := 0.0 setget _set_distance_to_ohio

# The total distance from start (Mauckport) to Ohio (Harrison).
# This has to be set in the game's initialization.
var total_map_distance_to_ohio := -1.0

func reset():
	orders = 5


func _set_reputation(value:int)->void:
	reputation = value
	emit_signal("reputation_changed", value)


func _set_time(value:float)->void:
	time = value
	emit_signal("time_changed", time)


func _set_distance_to_ohio(value)->void:
	distance_to_ohio = value
	emit_signal("distance_changed", distance_to_ohio)
