class_name ReducePlayerProjectilCostEffect
extends EffectBase

@export_range(0,1) var percent: float = 1

func apply_effect():
	GameEvents.blood_debt_effect_player_reduce_fire.emit(percent)
	
func get_description() -> String:
	var format_string = "Reduce cost of attacks by %s%%."
	description = format_string % [str(percent * 100)]
	return description
