extends Node2D

# Morgan's speed in units per second
export var movement_speed := 600

# The city to start the game
export(NodePath) var start_city

var _moving := false
var _path_follow : PathFollow2D = null
var _direction := +1

var _city : Node2D

onready var _morgan := $Morgan

func _ready():
	print(str(start_city))
	if start_city == "":
		print("Warning: start_city not specified. Using Mauckport.")
		start_city = $Cities/Mauckport.get_path()
	_city = get_node(start_city)
	_morgan.position = _city.position


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
	_ride($Cities/Mauckport, $Cities/Corydon)


func _ride(from:Node2D, to:Node2D):
	for road in $Roads.get_children():
		if road.connects(from, to):
			_path_follow = PathFollow2D.new()
			_path_follow.loop = false
			if road.end_city == to:
				_direction = 1
			else:
				_direction = -1
				# Note: Setting the unit_offset to 1 did not work here, so we have
				# to set the offset to the length of the corresponding curve
				_path_follow.offset = road.curve.get_baked_length()
			road.add_child(_path_follow)
			_moving = true
			_morgan.play_gallop_animation()


func _on_Mauckport_pressed():
	_ride($Cities/Corydon, $Cities/Mauckport)

