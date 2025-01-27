class_name IncreasePlayerDamageTaken
extends EffectBase

@export var multiplier: int = 2

func apply_effect():
	GameEvents.blood_debt_effect_player_damage_taken.emit(multiplier)
