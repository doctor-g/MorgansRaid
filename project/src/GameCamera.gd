extends Camera2D

# How fast the camera interpolates to new zoom levels
export var zoom_speed := 0.8

# How much is added to each margin when determining the visible bounding box
export var zoom_padding := 100

var _target : Node2D
var _target_zoom : float = 1


func show_all(cities:Array):
	_target = null
	
	# Make a rectangle that surrounds all the cities
	var rect := Rect2(cities[0].position.x, cities[0].position.y, 1, 1)
	for city in cities.slice(1, cities.size()):
		var additional = Rect2(city.position.x, city.position.y, 1, 1)
		rect = rect.merge(additional)
	
	# Add the padding around the box that bounds visible cities
	rect.position -= Vector2(zoom_padding, zoom_padding)
	rect.end += Vector2(zoom_padding*2, zoom_padding*2)
	
	# Calculate the zoom needed to show the rectangle
	var screen_size := Vector2(1024,768)       # Kludge
	var x_scale := rect.size.x / screen_size.x
	var y_scale := rect.size.y / screen_size.y 
	var scale := max(max(x_scale, y_scale), 1) # Never zoom in past 1.
	_target_zoom = scale
	
	# Finally, set the camera to the middle of that bounding rectangle
	position = Vector2(rect.position.x+rect.size.x/2, rect.position.y+rect.size.y/2)
	

func follow(node:Node):
	assert(node!=null)
	_target = node


func _process(delta:float):
	if _target != null:
		position = _target.position
	var new_zoom = lerp(zoom.x, _target_zoom, zoom_speed*delta)
	zoom = Vector2(new_zoom, new_zoom)
	
