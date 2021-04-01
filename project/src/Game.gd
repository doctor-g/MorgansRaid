extends Node2D

# Morgan's speed in units per second
export var movement_speed := 600

# The city to start the game
export(NodePath) var start_city

var _moving := false
var _path_follow : PathFollow2D = null
var _direction := +1

var _city : Node2D
var _destination : Node2D

onready var _morgan := $Morgan

func _ready():
	if start_city == "":
		print("Warning: start_city not specified. Using Mauckport.")
		start_city = $Cities/Mauckport.get_path()
	_city = get_node(start_city)
	_morgan.position = _city.position
	_listen_for_city_press()


func _remove_city_listeners():
	for child in $Cities.get_children():
		var city := child as Node2D
		if city.is_connected("pressed", self, "_on_City_pressed"):
			city.disconnect("pressed", self, "_on_City_pressed")


func _listen_for_city_press():
	# Add listeners to all the cities Morgan can go to from here
	for child in $Roads.get_children():
		var road := child as Road
		if road.has_terminus(_city):
			var possible_destination = road.get_other_terminus(_city)
			possible_destination.connect("pressed", self, "_on_City_pressed", [possible_destination])


func _process(delta):
	if _moving:
		assert(_path_follow != null)
		_path_follow.offset += movement_speed * delta * _direction
		_morgan.position = _path_follow.position
		if _end_of_road():
			_moving = false
			_morgan.play_idle_animation()
			_path_follow.get_parent().remove_child(_path_follow)
			_path_follow.queue_free()
			_path_follow = null
			_city = _destination
			_destination = null
			_listen_for_city_press()


func _end_of_road()->bool:
	return (_direction > 0 and _path_follow.unit_offset >= 1.0) \
	  or (_direction < 0 and _path_follow.unit_offset <= 0.0)
	

func _on_City_pressed(city:Node2D):
	_destination = city
	print("Now in %s, going to %s" % [_city.name, _destination.name])
	_remove_city_listeners()
	_ride(_city, _destination)


func _ride(from:Node2D, to:Node2D):
	for child in $Roads.get_children():
		var road := child as Road
		if road.connects(from, to):
			print("Using %s" % road.name)
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
			return
	assert(false, "There is no road from %s to %s" % [from.name,to.name])


