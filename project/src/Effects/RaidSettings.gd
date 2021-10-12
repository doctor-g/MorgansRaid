class_name RaidSettings
extends Object

var duration := 4
var reputation := 0
var reputation_multiplier := 1.0

# How many command points will you get on the next raid
var command_points := 0


func to_string()->String:
	return 'duration %f\nreputation %d\nmultiplier %f\ncommand_points %d\n' %\
	  [duration, reputation, reputation_multiplier, command_points]
