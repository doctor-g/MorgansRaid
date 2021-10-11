class_name ReputationGainEffect
extends 'res://src/Effects/Effect.gd'

const _UNINITIALIZED := -1

var amount := _UNINITIALIZED


func _init(_amount:int):
	amount = _amount


func run():
	assert(amount!=_UNINITIALIZED, "Amount was not initialized")
	GlobalState.reputation += amount
