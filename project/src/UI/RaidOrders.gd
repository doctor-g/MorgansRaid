extends Control

signal done

const TargetType := preload("res://src/Constants.gd").TargetType

# How many orders can be given
export var orders := 5 setget _set_orders

# How long to wait between the signature finishing and emitting done signal
export var post_signature_delay := 1.0

onready var _sign_orders_button := $SignOrdersButton

func _ready():
	_set_orders(orders)

	for target in $Targets.get_children():
		target.connect("priority_changed", self, "_on_Target_priority_changed", [target])
		target.update_orders(orders)


func reset():
	_sign_orders_button.reset()
	for target in $Targets.get_children():
		target.reset()


# Returns an array of {type:,priority:} maps.
func get_signed_orders()->Array:
	var result := []
	for node in $Targets.get_children():
		result.append({'type': node.type, 'priority': node.priority})
	return result


func _set_orders(value:int)->void:
	orders = value
	_update_label()
	for target in $Targets.get_children():
		target.update_orders(orders)


func _update_label():
	$OrdersRemainingLabel.text = "Orders remaining: %d" % orders


func _on_Target_priority_changed(new_priority, old_priority, _target)->void:
	if new_priority > old_priority:
		orders -= 1
	else:
		orders += 1
	
	_update_label()
	_sign_orders_button.update_orders(orders)
	for target in $Targets.get_children():
		target.update_orders(orders)


func _on_SignOrdersButton_done():
	$PostSignatureTimer.start(post_signature_delay)
	yield($PostSignatureTimer, "timeout")
	emit_signal("done")
