class_name EffectMap
extends Node

const _TargetType = Constants.TargetType
const _Priority = Constants.Priority

static func look_up(target, priority)->Object:
	# This table matches the one in the original source at raid/EffectMapFactory
	match target:
		_TargetType.MILITIA:
			match priority:
				_Priority.HIGH:
					return CompoundEffect.new([
						ReputationGainEffect.new(15),
						RaidTimeEffect.new(0)
					])
				_Priority.MEDIUM:
					return ReputationGainEffect.new(10)
				_Priority.LOW:
					return CompoundEffect.new([
						ReputationGainEffect.new(5),
						RaidTimeEffect.new(2)
					])
		
		_TargetType.SCOUT:
			match priority:
				_Priority.HIGH:
					return CommandPointEffect.new(7)
				_Priority.MEDIUM:
					return CommandPointEffect.new(5)
				_Priority.LOW:
					return CommandPointEffect.new(3)
					
		_TargetType.SUPPLIES:
			match priority:
				_Priority.HIGH:
					return MinSleepEffect.new(-2)
				_Priority.MEDIUM:
					return MinSleepEffect.new(-1)
				_Priority.LOW:
					return NoEffect.new()

		_TargetType.HORSES:
			match priority:
				_Priority.HIGH:
					return HorsesSpeedEffect.new(2)
				_Priority.MEDIUM:
					return NoEffect.new()
				_Priority.LOW:
					return HorsesSpeedEffect.new(-1)
		
		_TargetType.IMPEDE:
			match priority:
				_Priority.HIGH:
					return CompoundEffect.new([
						HorsesSpeedEffect.new(1),
						ReputationGainEffect.new(2)
					])
				_Priority.MEDIUM:
					return ReputationGainEffect.new(1)
				_Priority.LOW:
					return HorsesSpeedEffect.new(-1)
		
		_TargetType.CHAOS:
			match priority:
				_Priority.HIGH:
					return CompoundEffect.new([
						RaidTimeEffect.new(2),
						ReputationMultiplierEffect.new(1.25)
					])
				_Priority.MEDIUM:
					return CompoundEffect.new([
						RaidTimeEffect.new(1),
						ReputationMultiplierEffect.new(1.25)
					]) 
				_Priority.LOW:
					return NoEffect.new()
		
	# TODO: Handle railways
	
	assert(false, "Unrecognized target type: %s" % target)
	return null
