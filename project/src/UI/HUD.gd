extends Control

export var sunrise := 6.0
export var sunset := 12.0 + 9.0

# How many hours before and after sunrise and sunset to fade
export var hours_fade_range := 0.5

export var night_modulation_alpha := 0.8

onready var _reputation_label := $Footer/ReputationLabel
onready var _pathfollow := $Header/Path2D/PathFollow2D
onready var _shade := $Shade


func _ready():
	GlobalState.connect("reputation_changed", self, "_on_GlobalState_reputation_changed")
	GlobalState.connect("time_changed", self, "_on_GlobalState_time_changed")

	
func _on_GlobalState_reputation_changed(new_reputation:int)->void:
	_reputation_label.text = str(new_reputation)


func _on_GlobalState_time_changed(time:float)->void:
	# Update sun's position
	var hour_of_the_day := fmod(time, 24)
	var sun_progress := range_lerp(hour_of_the_day, sunrise, sunset, 0.0, 1.0)
	_pathfollow.unit_offset = sun_progress
	
	# Update screen fade
	var alpha : float
	if hour_of_the_day < 12:
		alpha = range_lerp(hour_of_the_day, \
			sunrise-hours_fade_range, sunrise+hours_fade_range, \
			night_modulation_alpha, 0)
	else:
		alpha = range_lerp(hour_of_the_day, \
			sunset-hours_fade_range, sunset+hours_fade_range,\
			0, night_modulation_alpha)
	alpha = clamp(alpha, 0, night_modulation_alpha)
	_shade.modulate.a = alpha
