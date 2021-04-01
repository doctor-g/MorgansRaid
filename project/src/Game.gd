extends Node2D

# Morgan's speed in units per second
export var movement_speed := 600

var _moving := false
var _path_follow : PathFollow2D = null
var _direction := +1

onready var _morgan := $Morgan

func _process(delta):
	if _moving:
		_path_follow.offset += movement_speed * delta * _direction
		_morgan.position = _path_follow.position
		if _end_of_road():
			_moving = false
			_morgan.play_idle_animation()
			_path_follow.queue_free()
			_path_follow = null


func _end_of_road()->bool:
	return (_direction > 0 and _path_follow.unit_offset >= 1.0) \
	  or (_direction < 0 and _path_follow.unit_offset <= 0.0)
	


# The following are obviously placeholders of the real movement system,
# but they demonstrate the capability
func _on_Corydon_pressed():
	_path_follow = PathFollow2D.new()
	_path_follow.loop = false
	_direction = +1
	$MauckportCorydonRoad.add_child(_path_follow)
	_moving = true
	_morgan.play_gallop_animation()


func _on_Mauckport_pressed():
	_path_follow = PathFollow2D.new()
	_path_follow.loop = false
	_direction = -1
	# Note: Setting the unit_offset to 1 did not work here, so we have
	# to set the offset to the length of the corresponding curve
	_path_follow.offset = $MauckportCorydonRoad.curve.get_baked_length()
	$MauckportCorydonRoad.add_child(_path_follow)
	_moving = true
	_morgan.play_gallop_animation()

