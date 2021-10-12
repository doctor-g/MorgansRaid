class_name ReputationMultiplierEffect
extends Effect

const _UNINITIALIZED := 0.0

var factor := _UNINITIALIZED


func _init(_amount:float):
	factor = _amount


func apply_to(settings:RaidSettings)->RaidSettings:
	assert(factor!=_UNINITIALIZED, "Factor was not initialized")
	settings.reputation_multiplier = factor
	return settings
