class_name MinSleepEffect
extends 'res://src/Effects/Effect.gd'

const _UNINITIALIZED := -100

var value := _UNINITIALIZED

func _init(_value:int):
	value = _value


func run():
	assert(value!=_UNINITIALIZED, "Value was not initialized")
	print('Min sleep effect. Ignored.')
