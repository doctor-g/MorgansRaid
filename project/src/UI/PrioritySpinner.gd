extends Control

signal priority_changed(new_priority, old_priority)

export(Constants.Priority) var priority = Constants.Priority.LOW setget _set_priority

var _orders_remaining : int

onready var _label := $PriorityLabel

func _set_priority(value)->void:
	priority = value
	
	match priority:
		Constants.Priority.LOW:
			_label.text = "Low"
		Constants.Priority.MEDIUM:
			_label.text = "Medium"
		Constants.Priority.HIGH:
			_label.text = "High"
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
	$VBoxContainer/UpButton.disabled = priority == Constants.Priority.HIGH or _orders_remaining == 0
	$VBoxContainer/DownButton.disabled = priority == Constants.Priority.LOW
