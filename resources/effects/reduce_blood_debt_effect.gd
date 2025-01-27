class_name ReduceBloodDebtEffect
extends EffectBase

@export var amount: float = 1

func apply_effect():
	GameEvents.blood_debt_effect_reduce.emit(amount)
