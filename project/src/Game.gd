extends Node2D

enum State {
	CHOOSING_DESTINATION,
	MOVING,
	GIVING_ORDERS
}

# Morgan's speed in units per second
export var movement_speed := 600

# The city to start the game
export(NodePath) var start_city

var _moving := false
var _path_follow : PathFollow2D = null
var _direction := +1

var _city : Node2D
var _destination : Node2D

var _state

onready var _morgan := $Morgan
onready var _camera := $Camera

onready var _raid_ui := $HUD/RaidUI
onready var _city_placard := $HUD/RaidUI/CityPlacard
onready var _raid_orders_ui := $HUD/RaidUI/RaidOrders


func _ready():
	if start_city == "":
		print("Warning: start_city not specified. Using Mauckport.")
		start_city = $Cities/Mauckport.get_path()
	_city = get_node(start_city)
	_morgan.position = _city.position
	_camera.position = _morgan.position
	
	# There is a problem right now where, because we go right into
	# movement, Corydon does not yet think it is on-screen.
	# The kludge here is to wait a very short amount of time before
	# listening for city selection. 
	# Once we add the intro narrative, this should no longer be necessary
	yield(get_tree().create_timer(0.1), "timeout")
	_enter_state(State.CHOOSING_DESTINATION)


func _enter_state(new_state):
	# Leave the old state
	match _state:
		State.CHOOSING_DESTINATION:
			_remove_city_listeners()
		State.GIVING_ORDERS:
			_raid_ui.visible = false
	
	_state = new_state
	
	# Enter the new state
	match _state:
		State.CHOOSING_DESTINATION:
			_listen_for_city_press()
		State.GIVING_ORDERS:
			_city_placard.city = _city
			_raid_orders_ui.reset()
			_raid_orders_ui.orders = 5
			_raid_ui.visible = true
		

func _listen_for_city_press():
	var cities_on_screen = [_city]
	
	# Add listeners to all the cities Morgan can go to from here
	for child in $Roads.get_children():
		var road := child as Road
		if road.has_terminus(_city):
			var possible_destination : City = road.get_other_terminus(_city)
			possible_destination.selectable = true
			cities_on_screen.append(possible_destination)
			possible_destination.connect("pressed", self, "_on_City_pressed", [possible_destination])
				
	# Tell the camera to show all those selectable cities
	_camera.show_all(cities_on_screen)


func _process(delta):
	match _state:
		State.MOVING:
			assert(_path_follow != null)
			_path_follow.offset += movement_speed * delta * _direction
			_morgan.position = _path_follow.position
			if _end_of_road():
				_morgan.play_idle_animation()
				_path_follow.get_parent().remove_child(_path_follow)
				_path_follow.queue_free()
				_path_follow = null
				_city = _destination
				_destination = null
				_enter_state(State.GIVING_ORDERS)


func _end_of_road()->bool:
	return (_direction > 0 and _path_follow.unit_offset >= 1.0) \
	  or (_direction < 0 and _path_follow.unit_offset <= 0.0)
	

func _on_City_pressed(destination:Node2D):
	_ride(_city, destination)
	_camera.follow(_morgan)


func _ride(from:Node2D, to:Node2D):
	assert(from!=null)
	assert(to!=null)
	
	_enter_state(State.MOVING)
	
	_destination = to
	print("Now in %s, going to %s" % [_city.name, _destination.name])
	_remove_city_listeners()
	
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


func _remove_city_listeners():
	for child in $Cities.get_children():
		var city := child as City
		city.selectable = false
		if city.is_connected("pressed", self, "_on_City_pressed"):
			city.disconnect("pressed", self, "_on_City_pressed")


func _on_RaidOrders_done():
	_enter_state(State.CHOOSING_DESTINATION)
