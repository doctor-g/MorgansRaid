extends Node2D



# The following are obviously placeholders of the real movement system,
# but they demonstrate the capability
func _on_Corydon_pressed():
	$Morgan.position = $Cities/Corydon.position
func _on_Mauckport_pressed():
	$Morgan.position = $Cities/Mauckport.position
