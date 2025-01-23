extends Node

signal camera_shake(camera_shake_strength: float)
signal player_blood_gained(amount: float)
signal player_health_updated(current_health: float)

signal wave_started(wave_number: int)
signal wave_complete(wave_number: int)
signal wave_start_next()

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
	
var floating_text_scene = preload("res://ui/floating_text.tscn")

func create_negative_numbers(global_position: Vector2, damage: float):
	var floating_text = floating_text_scene.instantiate() as Node2D
	get_tree().get_first_node_in_group("foreground_layer").add_child(floating_text)
	floating_text.global_position = global_position + (Vector2.UP * 16)
	var format_screen = "-%0.0f"
	floating_text.start(format_screen % damage)
	
func create_positive_numbers(global_position: Vector2, damage: float):
	var floating_text = floating_text_scene.instantiate() as Node2D
	get_tree().get_first_node_in_group("foreground_layer").add_child(floating_text)
	floating_text.global_position = global_position + (Vector2.UP * 16)
	var format_screen = "+%0.0f"
	floating_text.start(format_screen % damage)
	
