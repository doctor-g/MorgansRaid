class_name RaidTimeEffect
extends Effect

const _UNINITIALIZED := -1

var value := _UNINITIALIZED


func _init(_value:int):
	value = _value


func run():
	assert(value!=_UNINITIALIZED, "Value was not initialized")
	print('Raid Time effect. Ignored.')
