class_name ReduceBloodDebtEffect
extends EffectBase

@export var amount: float = 1

func apply_effect():
	GameEvents.blood_debt_effect_reduce.emit(amount)
	
func get_description() -> String:
	var format_string = "Reduce Blood Debt by %s%%."
	description = format_string % [str(amount * 100)]
	return description
