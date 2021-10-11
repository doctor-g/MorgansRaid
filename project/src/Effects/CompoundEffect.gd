class_name CompoundEffect
extends Effect

# The array of effects
var effects := []


func _init(_effects:Array):
	effects = _effects


func apply_to(settings:RaidSettings)->RaidSettings:
	assert(effects.size()>0, "No effects are part of this compound effect")
	for effect in effects:
		settings = effect.apply_to(settings)
	return settings
