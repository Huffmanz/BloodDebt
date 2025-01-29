extends Node

#player
signal camera_shake(camera_shake_strength: float)
signal player_blood_gained(amount: float)
signal player_health_updated(current_health: float)
signal player_remove_blood(amount: int)
signal player_died()

#wave management
signal wave_started(wave_number: int)
signal wave_complete(wave_number: int)
signal wave_start_next()

signal blood_debt_updated(amount: int)

#effects
signal blood_debt_effect_reduce(percentage: float)
signal blood_debt_effect_add(percentage: float)
signal blood_debt_effect_reduce_wave_time(percentage: float)
signal blood_debt_effect_multiplier(amount: int)
signal blood_debt_effect_player_damage_taken(multiplier: float)
signal blood_debt_effect_player_reduce_fire(percentage: float)
signal blood_debt_effect_enemy_spawn_rate(multiplier: float)
signal blood_debt_effect_enemy_health(multiplier: float)
signal blood_debt_effect_enemy_drop_rate(multiplier: int)
signal blood_debt_effect_player_damage(multiplier: float)

func emit_camera_shake(camera_shake_strength: float) -> void:
	camera_shake.emit(camera_shake_strength)
	
func emit_player_blood_gained(amount: float):
	player_blood_gained.emit(amount)
	
func emit_player_health_updated(amount: float):
	player_health_updated.emit(amount)
