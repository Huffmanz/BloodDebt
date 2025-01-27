class_name MultiplyBloodDebtEffect
extends EffectBase

@export var amount: int = 2

func apply_effect():
	GameEvents.blood_debt_effect_multiplier.emit(amount)

func get_description() -> String:
	var format_string = "Increase next blood payment by %1.2fx."
	description = format_string % [amount]
	return description
