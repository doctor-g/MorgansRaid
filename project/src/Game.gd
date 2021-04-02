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
onready var _arrows := $Morgan/Camera2D/Arrows

func _ready():
	if start_city == "":
		print("Warning: start_city not specified. Using Mauckport.")
		start_city = $Cities/Mauckport.get_path()
	_city = get_node(start_city)
	_morgan.position = _city.position
	
	# There is a problem right now where, because we go right into
	# movement, Corydon does not yet think it is on-screen.
	# The kludge here is to wait a very short amount of time before
	# listening for city selection. 
	# Once we add the intro narrative, this should no longer be necessary
	yield(get_tree().create_timer(0.1), "timeout")
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
			var possible_destination : City = road.get_other_terminus(_city)
			if possible_destination.is_on_screen():
				possible_destination.connect("pressed", self, "_on_City_pressed", [possible_destination])
			else:
				print("Possible destination is %s" % possible_destination.name)
				var screen_size := get_viewport_rect().size
				
				var morgan_screen_pos : Vector2 = _morgan.get_global_transform_with_canvas().origin
				var city_screen_pos := possible_destination.get_global_transform_with_canvas().origin
				
				var side_options = [
					[   # Right side
						Vector2(screen_size.x, 0), Vector2(screen_size.x,screen_size.y), 
						preload("res://src/Arrows/EastArrow.tscn")
					],
					[   # Left side
						Vector2(0,0), Vector2(0, screen_size.y), 
						preload("res://src/Arrows/WestArrow.tscn")
					],
					[   # Top
						Vector2(0,0), Vector2(screen_size.x, 0), 
						preload("res://src/Arrows/NorthArrow.tscn")
					],
					[   # Bottom
						Vector2(0, screen_size.y), Vector2(screen_size.x, screen_size.y), 
						preload("res://src/Arrows/SouthArrow.tscn")
					]
				]
				for option in side_options:
					var point = Geometry.segment_intersects_segment_2d(\
						morgan_screen_pos, city_screen_pos, \
						option[0], option[1])
					if point is Vector2:
						var arrow = option[2].instance()
						arrow.position = point
						arrow.city_name = possible_destination.name
						arrow.connect("pressed", self, "_on_OffscreenDestinationArrow_pressed", [possible_destination])				
						_arrows.add_child(arrow)
						continue


func _on_OffscreenDestinationArrow_pressed(city:City)->void:
	_ride(_city, city)


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
	

func _on_City_pressed(destination:Node2D):
	_ride(_city, destination)


func _ride(from:Node2D, to:Node2D):
	assert(from!=null)
	assert(to!=null)
	
	_destination = to
	print("Now in %s, going to %s" % [_city.name, _destination.name])
	_remove_city_listeners()
	_remove_offscreen_destination_arrows()
	
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


func _remove_offscreen_destination_arrows()->void:
	for arrow in _arrows.get_children():
		arrow.disconnect("pressed", self, "_on_OffscreenDestinationArrow_pressed")
		arrow.queue_free()


func _on_OffScreenDestinationOverlay_direction_selected(_dir:int, city:City):
	_ride(_city, city)
