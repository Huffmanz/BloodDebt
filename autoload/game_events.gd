extends Node

signal camera_shake(camera_shake_strength: float)
signal player_blood_gained(amount: float)
signal player_health_updated(current_health: float)

signal wave_started(wave_number: int)
signal wave_complete(wave_number: int)

func emit_camera_shake(camera_shake_strength: float) -> void:
	camera_shake.emit(camera_shake_strength)
	
func emit_player_blood_gained(amount: float):
	player_blood_gained.emit(amount)
	
func emit_player_health_updated(amount: float):
	player_health_updated.emit(amount)

func frameFreeze(timeScale, duration):
	Engine.time_scale = timeScale
	await get_tree().create_timer(duration * timeScale).timeout
	Engine.time_scale = 1.0
	
