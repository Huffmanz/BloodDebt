class_name IncreaseEnemyDropRate
extends EffectBase

@export_range(1,2) var multiplier: int = 2

func apply_effect():
	GameEvents.blood_debt_effect_enemy_drop_rate.emit(multiplier)

func get_description() -> String:
	var format_string = "Increase enemy drop rate by %1.2fx."
	description = format_string % [multiplier]
	return description
