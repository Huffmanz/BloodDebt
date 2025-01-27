class_name MultiplyBloodDebtEffect
extends EffectBase

@export var amount: int = 2

func apply_effect():
	GameEvents.blood_debt_effect_multiplier.emit(amount)
