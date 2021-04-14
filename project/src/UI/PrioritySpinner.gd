extends Control
tool

signal priority_changed(new_priority, old_priority)

export(Enums.Priority) var priority := Enums.Priority.LOW setget _set_priority

var _orders_remaining : int

func _set_priority(value)->void:
	priority = value
	
	# Cannot use onready variables here because this is a tool
	var label = $PriorityLabel
	
	match priority:
		Enums.Priority.LOW:
			label.text = "Low"
		Enums.Priority.MEDIUM:
			label.text = "Medium"
		Enums.Priority.HIGH:
			label.text = "High"
	_update_button_status()


func _on_UpButton_pressed():
	_set_priority(priority+1)
	emit_signal("priority_changed", priority, priority-1)


func _on_DownButton_pressed():
	_set_priority(priority-1)
	emit_signal("priority_changed", priority, priority+1)


func update_orders(orders_remaining:int)->void:
	_orders_remaining = orders_remaining
	_update_button_status()


func _update_button_status():
	$VBoxContainer/UpButton.disabled = priority == Enums.Priority.HIGH or _orders_remaining == 0
	$VBoxContainer/DownButton.disabled = priority == Enums.Priority.LOW
