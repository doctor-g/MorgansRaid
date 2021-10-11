class_name RaidTimeEffect
extends Effect

const _UNINITIALIZED := -1

# The number of hours to modify the raiding time
var value := _UNINITIALIZED


func _init(_value:int):
	value = _value


func apply_to(settings:RaidSettings)->RaidSettings:
	assert(value!=_UNINITIALIZED, "Value was not initialized")
	settings.duration += value
	return settings
