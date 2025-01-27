class_name IncreaseEnemySpawnRate
extends EffectBase

@export_range(1,2) var multiplier: float = 1.5

func apply_effect():
	GameEvents.blood_debt_effect_enemy_spawn_rate.emit(multiplier)
