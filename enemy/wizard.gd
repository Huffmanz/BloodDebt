extends Enemy

const ENEMY_PROJECTILE = preload("res://combat/enemy_projectile.tscn")
const MOVE_RADIUS = 150

@onready var state_timer: Timer = $StateTimer
@onready var fire_rate_timer: Timer = $FireRateTimer
@onready var weapon_pivot: Marker2D = $WeaponPivot
@onready var muzzle: Marker2D = $WeaponPivot/Muzzle

var wizard_gib_component = preload("res://components/gib_component/wizard_gib_component.tscn")

var STATE_OPTIONS = [fire_state, move_state]
var state = move_state : set = set_state
var state_init = true : get = get_state_init
var move_location:Vector2

var disappear_tween :Tween
var reappear_tween: Tween

func set_state(value):
	state = value
	state_init = true
	
func get_state_init():
	var was = state_init
	state_init = false
	return was
	
func _init() -> void:
	gib_component = wizard_gib_component

func _process(delta):
	if dead:
		state_timer.stop()
		fire_rate_timer.stop()
		return
	state.call(delta)
	flip()

func fire_state(delta):
	if state_init:
		state_timer.start(randf_range(4.0, 6.0))
		state_timer.timeout.connect(set_state.bind(move_state), CONNECT_ONE_SHOT)
		
	if fire_rate_timer.time_left == 0:
		weapon_pivot.rotation_degrees += 17
		fire_rate_timer.start()
		var projectile = ENEMY_PROJECTILE.instantiate()
		get_tree().current_scene.add_child(projectile)
		projectile.global_position = muzzle.global_position
		projectile.rotation = weapon_pivot.rotation
		
		
func move_state(delta):
	if state_init:
		get_move_location()
		disappear_tween = create_tween()
		disappear_tween.tween_property(visuals, "modulate:a", 0, 1.0)\
			.set_ease(Tween.EASE_OUT)\
			.set_trans(Tween.TRANS_CUBIC)
		disappear_tween.finished.connect(reappear)

func reappear() -> void:
	global_position = move_location
	if reappear_tween:
		reappear_tween.kill()
	reappear_tween = create_tween()
	reappear_tween.tween_property(visuals, "modulate:a", 1, 1.0)\
		.set_ease(Tween.EASE_OUT)\
		.set_trans(Tween.TRANS_CUBIC)
	reappear_tween.finished.connect(set_state.bind(fire_state))
	
func get_move_location():  
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return Vector2.ZERO
	move_location = Vector2.ZERO
	var random_direction = Vector2.RIGHT.rotated(randf_range(0, TAU))
	for i in 4:
		move_location = player.global_position + (random_direction * MOVE_RADIUS)
		var additonal_check_offset = random_direction * 20
		var query_parameters = PhysicsRayQueryParameters2D.create(player.global_position, move_location + additonal_check_offset, 1 << 0)
		var result = get_tree().root.world_2d.direct_space_state.intersect_ray(query_parameters)
		
		if result.is_empty():
			return move_location
		else:
			random_direction = random_direction.rotated(deg_to_rad(90))
			
	return move_location
	
func flip():
	var player  = get_tree().get_first_node_in_group("player") as Node2D
	var move_sign = sign((global_position.direction_to(player.global_position)).x)
	if(move_sign != 0):
		visuals.scale = Vector2(move_sign, 1)
		
	if move_sign == 0:
		move_sign = sign((get_global_mouse_position() - global_position).x)
		if(move_sign != 0):
			visuals.scale = Vector2(move_sign, 1)
