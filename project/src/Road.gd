extends Path2D


export(NodePath) var start_city_path
export(NodePath) var end_city_path

var start_city : Node setget , _get_start_city
var end_city : Node setget , _get_end_city


func _get_start_city()->Node:
	return get_node(start_city_path)


func _get_end_city()->Node:
	return get_node(end_city_path)


func connects(node1:Node, node2:Node)->bool:
	return _get_start_city()==node1 and _get_end_city() == node2 \
		or _get_start_city()==node2 and _get_end_city() == node1
