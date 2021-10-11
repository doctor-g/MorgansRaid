class_name ReputationGainEffect
extends 'res://src/Effects/Effect.gd'

const _UNINITIALIZED := -1

var amount := _UNINITIALIZED


func _init(_amount:int):
	amount = _amount


func apply_to(settings:RaidSettings)->RaidSettings:
	assert(amount!=_UNINITIALIZED, "Amount was not initialized")
	settings.reputation += amount
	return settings
