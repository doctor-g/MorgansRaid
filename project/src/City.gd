class_name City
extends Node2D
tool

signal pressed

const _SMALL_THRESHOLD := 1499
const _MEDIUM_THRESHOLD := 4999

export var city_name : String = "UNNAMED" setget _set_city_name
export var population : int = 0 setget _set_population

var selectable := false setget _set_selectable

onready var _highlight := $Highlight
onready var _animation_player := $AnimationPlayer


# Report whether this city is currently on screen enough to be selectable.
# It is not enough to say that just a bit of it is onscreen, and hence
# the use of multiple regions. A VisibilityNotifier2D triggers if any part
# of it is visible, but we need multiple areas to be visible.
func is_on_screen()->bool:
	for notifier in $VisibilityNotifiers.get_children():
		var sensor := notifier as VisibilityNotifier2D
		if not sensor.is_on_screen():
			return false
	return true


func _set_city_name(value:String)->void:
	city_name = value
	$Label.text = value


func _on_Area2D_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed:
		emit_signal("pressed")


func _set_population(value:int)->void:
	population = value
	if population <= _SMALL_THRESHOLD:
		$CityIcon.size = CityIcon.Size.SMALL
	elif population <= _MEDIUM_THRESHOLD:
		$CityIcon.size = CityIcon.Size.MEDIUM
	else:
		$CityIcon.size = CityIcon.Size.LARGE


func _set_selectable(value:bool)->void:
	selectable = value
	if selectable:
		_highlight.visible = true
		_animation_player.play("highlight")
	else:
		_highlight.visible = false
		_animation_player.stop()
