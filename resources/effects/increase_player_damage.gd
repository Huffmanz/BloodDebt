class_name IncreasePlayerDamage
extends EffectBase

@export var multiplier: float = 3

func apply_effect():
	GameEvents.blood_debt_effect_player_damage.emit(multiplier)

func get_description() -> String:
	var format_string = "Player deals %1.2fx more damage."
	description = format_string % [multiplier]
	return description
