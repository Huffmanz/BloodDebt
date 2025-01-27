class_name WaveManager
extends Node

signal wave_difficulty_increased(arena_difficulty: int)
const DIFFICULTY_INTERVAL = 5

@onready var timer = $Timer

var wave_difficulty = 0
var current_wave = 0
var spawn_multiplier = 1

func _ready():
	timer.timeout.connect(on_timer_timeout)
	GameEvents.wave_start_next.connect(start_wave)
	GameEvents.blood_debt_effect_enemy_spawn_rate.connect(_increase_spawn_multiplier)
	start_wave()
	
func _process(delta):
	var next_time_target = timer.wait_time - (wave_difficulty + 1) * DIFFICULTY_INTERVAL
	if timer.time_left <= next_time_target:
		wave_difficulty += 1
		wave_difficulty_increased.emit(wave_difficulty)
		
func start_wave():
	var next_wave_time = timer.wait_time + current_wave * DIFFICULTY_INTERVAL
	next_wave_time *= spawn_multiplier
	timer.wait_time = next_wave_time
	current_wave += 1
	timer.start()
	GameEvents.wave_started.emit(current_wave)
	
func _increase_spawn_multiplier(multiplier: float):
	spawn_multiplier = multiplier
	
func get_time_elapsed():
	return timer.time_left
	
func on_timer_timeout():
	ScreenTransition.transition()
	await ScreenTransition.transitioned_halfway
	#for enemy in get_tree().get_nodes_in_group("enemy"):
	#	enemy.queue_free()
	#(get_tree().get_first_node_in_group("player") as Player).reset_location()
	spawn_multiplier = 1
	GameEvents.wave_complete.emit(current_wave)
	#MetaProgression.save()
