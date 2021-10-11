class_name CompoundEffect
extends Effect

# The array of effects
var effects := []


func _init(_effects:Array):
	effects = _effects


func run():
	assert(effects.size()>0, "No effects are part of this compound effect")
	for effect in effects:
		effect.run()
