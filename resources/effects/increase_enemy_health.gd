class_name IncreaseEnemyHealth
extends EffectBase

@export_range(1,2) var multiplier: float = 1.5

func apply_effect():
	GameEvents.blood_debt_effect_enemy_health.emit(multiplier)
	
func get_description() -> String:
	var format_string = "Increase enemy health by %1.2fx."
	description = format_string % [multiplier]
	return description
