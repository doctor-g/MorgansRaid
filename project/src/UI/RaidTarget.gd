extends VBoxContainer
tool

signal priority_changed(new_priority, old_priority)

export var icon:StreamTexture setget _set_icon


func _set_icon(value:StreamTexture)->void:
	icon = value
	$TextureRect.texture = value


func _on_PrioritySpinner_priority_changed(new_priority, old_priority):
	emit_signal("priority_changed", new_priority, old_priority)


func update_orders(orders_remaining:int)->void:
	$PrioritySpinner.update_orders(orders_remaining)
	

func reset():
	$PrioritySpinner.priority = Enums.Priority.LOW
