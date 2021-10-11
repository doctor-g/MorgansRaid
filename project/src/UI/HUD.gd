extends Control


onready var _reputation_label := $Footer/ReputationLabel

func _ready():
	GlobalState.connect("reputation_changed", self, "_on_GlobalState_reputation_changed")
	
	
func _on_GlobalState_reputation_changed(new_reputation:int)->void:
	_reputation_label.text = str(new_reputation)
