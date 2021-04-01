class_name Road
extends Path2D


export(NodePath) var start_city_path
export(NodePath) var end_city_path

var start_city : Node setget , _get_start_city
var end_city : Node setget , _get_end_city


func _ready():
	assert(start_city_path!="", "Start city path not specified for %s" % name)
	assert(end_city_path!="", "End city path not specified for %s" % name)


func _get_start_city()->Node:
	return get_node(start_city_path)


func _get_end_city()->Node:
	return get_node(end_city_path)


func connects(node1:Node, node2:Node)->bool:
	assert(node1!=node2, "The parameters must be different cities.")
	return has_terminus(node1) and has_terminus(node2)


func has_terminus(city:Node)->bool:
	return _get_start_city()==city or _get_end_city()==city


# Given one city, return the one at the other end of the road
func get_other_terminus(city:Node)->Node:
	return _get_start_city() if _get_end_city()==city else _get_end_city()
