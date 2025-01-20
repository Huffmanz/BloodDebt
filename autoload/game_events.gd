extends Node

signal camera_shake(camera_shake_strength: float)

func emit_camera_shake(camera_shake_strength: float) -> void:
	camera_shake.emit(camera_shake_strength)

func frameFreeze(timeScale, duration):
	Engine.time_scale = timeScale
	await get_tree().create_timer(duration * timeScale).timeout
	Engine.time_scale = 1.0
	
