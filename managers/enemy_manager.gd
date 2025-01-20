extends Node

const SPAWN_RADIUS = 350;

@export var basic_enemy_scene: PackedScene
@export var wave_timer_manager:WaveManager

@onready var timer = $Timer
var base_spawn_time = 0
var enemy_table = WeightedTable.new()

func _ready():
	enemy_table.add_item(basic_enemy_scene, 10)
	timer.timeout.connect(on_timer_timeout)
	wave_timer_manager.wave_difficulty_increased.connect(on_wave_difficulty_increased)
	base_spawn_time = timer.wait_time
	GameEvents.wave_complete.connect(_wave_complete)
	GameEvents.wave_started.connect(_wave_started)
	
func _wave_complete(wave_number: int):
	timer.stop()
	
func _wave_started(wave_number: int):
	timer.start()
	
func get_spawn_position():  
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return Vector2.ZERO
	var spawn_position = Vector2.ZERO
	var random_direction = Vector2.RIGHT.rotated(randf_range(0, TAU))
	for i in 4:
		
		spawn_position = player.global_position + (random_direction * SPAWN_RADIUS)
		var additonal_check_offset = random_direction * 20
		var query_parameters = PhysicsRayQueryParameters2D.create(player.global_position, spawn_position + additonal_check_offset, 1 << 0)
		var result = get_tree().root.world_2d.direct_space_state.intersect_ray(query_parameters)
		
		if result.is_empty():
			return spawn_position
		else:
			random_direction = random_direction.rotated(deg_to_rad(90))
			
	return spawn_position
	
func on_timer_timeout():
	timer.start()
	
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	var enemy_scene = enemy_table.pick_item()
	var enemy = enemy_scene.instantiate() as Node2D
	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
	if entities_layer == null:
		return
	
	entities_layer.add_child(enemy)
	enemy.global_position = get_spawn_position()

func on_wave_difficulty_increased(wave_difficulty: int):
	var time_off = (.1 /12) * wave_difficulty # 12 5 second segments in a minute
	time_off = min(time_off, .8)
	timer.wait_time = base_spawn_time - time_off
	if wave_difficulty == 6:
		print()
		#enemy_table.add_item(wizard_enemy_scene, 15)
	elif wave_difficulty == 18:
		print()
		#enemy_table.add_item(bat_enemy_scene, 10)
	
