extends Control

# Emitted when the signature is complete
signal done

onready var _button : TextureButton = $TextureButton
onready var _signature : AnimatedSprite = $Signature

func reset():
	_button.visible = true
	_signature.visible = false
	_signature.frame = 0


func update_orders(orders_remaining:int)->void:
	_button.disabled = orders_remaining > 0


func _on_TextureButton_pressed():
	_button.visible = false
	_signature.visible = true
	_signature.play()


func _on_Signature_animation_finished():
	_signature.stop()
	_signature.frame = _signature.frames.get_frame_count("default") - 1
	emit_signal("done")
