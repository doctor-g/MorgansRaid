extends Node

signal reputation_changed(new_reputation)

var reputation := 0 setget _set_reputation


func _set_reputation(value:int)->void:
	reputation = value
	emit_signal("reputation_changed", value)
