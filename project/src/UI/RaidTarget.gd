extends VBoxContainer
tool

const TargetType = preload("res://src/Constants.gd").TargetType
const Priority = preload("res://src/Constants.gd").Priority

signal priority_changed(new_priority, old_priority)

export(TargetType) var type
export var icon:StreamTexture setget _set_icon

var priority setget , _get_priority


func _set_icon(value:StreamTexture)->void:
	icon = value
	$TextureRect.texture = value


func _on_PrioritySpinner_priority_changed(new_priority, old_priority):
	emit_signal("priority_changed", new_priority, old_priority)


func update_orders(orders_remaining:int)->void:
	$PrioritySpinner.update_orders(orders_remaining)
	

func reset():
	$PrioritySpinner.priority = Priority.LOW


func _get_priority():
	return $PrioritySpinner.priority
