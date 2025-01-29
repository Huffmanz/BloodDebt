class_name ReduceWaveTimerEffect
extends EffectBase

@export_range(0,1) var percent: float = 1

func apply_effect():
	GameEvents.blood_debt_effect_reduce_wave_time.emit(percent)
	
func get_description() -> String:
	var format_string = "Reduce time until next debt payment by %s%%."
	description = format_string % [str(percent * 100)]
	return description
