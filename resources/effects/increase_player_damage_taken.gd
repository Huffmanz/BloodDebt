class_name IncreasePlayerDamageTaken
extends EffectBase

@export var multiplier: int = 2

func apply_effect():
	GameEvents.blood_debt_effect_player_damage_taken.emit(multiplier)

func get_description() -> String:
	var format_string = "Player takes %1.2fx more damage."
	description = format_string % [multiplier]
	return description
