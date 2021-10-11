extends Node

signal reputation_changed(new_reputation)

var reputation := 0 setget _set_reputation

# Number of orders that can be given next time
var orders := 5


func reset():
	orders = 5


func _set_reputation(value:int)->void:
	reputation = value
	emit_signal("reputation_changed", value)
