class_name AddBloodDebtEffect
extends EffectBase

@export_range(0.0,1.0) var percent: float = 1

func apply_effect():
	GameEvents.blood_debt_effect_add.emit(percent)
	
func get_description() -> String:
	var format_string = "Increase blood bebt by %s%%."
	description = format_string % [str(percent * 100)]
	return description
