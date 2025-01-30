extends Enemy

const ARCHER_GIB_COMPONENT = preload("res://components/gib_component/archer_gib_component.tscn")
const ARROW_PROJECTILE = preload("res://combat/arrow_projectile.tscn")

@export var ghost_scene: PackedScene

@onready var animated_sprite_2d: AnimatedSprite2D = $Visuals/AnimatedSprite2D
@onready var weapon_visuals: Node2D = $Visuals/WeaponVisuals
@onready var bow: AnimatedSprite2D = $Visuals/WeaponVisuals/Bow
@onready var dashing_component: VelocityComponent = $DashingComponent
@onready var dash_cooldown: Timer = $DashingComponent/DashCooldown
@onready var ghost_timer: Timer = $DashingComponent/GhostTimer
@onready var dash_timer: Timer = $DashingComponent/DashTimer
@onready var dash_particles: CPUParticles2D = $DashParticles


var STATE_OPTIONS = [fire_state, dash_state]
var state = fire_state : set = set_state
var state_init = true : get = get_state_init
var move_location:Vector2
var dashing := false
var dash_direction = Vector2.ZERO
var shots_to_fire := 3

func set_state(value):
	state = value
	state_init = true
	
func get_state_init():
	var was = state_init
	state_init = false
	return was

var player: Player : get = _get_player

func _get_player():
	if not player:
		player = Utils.get_player()
	return player

func _ready() -> void:
	super._ready()
	ghost_timer.timeout.connect(add_ghost)
	dash_timer.timeout.connect(_dash_timeout)
	dash_cooldown.timeout.connect(_dash_cooldown)
	dash_particles.emitting = false

func _init() -> void:
	gib_component = ARCHER_GIB_COMPONENT
	state = STATE_OPTIONS.pick_random()

	
func _physics_process(delta: float) -> void:
	if dead:
		return
	state.call(delta)
	
func fire_state(delta: float) -> void:
	if state_init:
		shots_to_fire = randi_range(1,3)
	weapon_visuals.look_at(player.global_position)
	flip()
	fire()
	if shots_to_fire <= 0:
		state = dash_state
	
func dash_state(delta: float)-> void:
	if state_init:
		dashing = true
		dash_timer.start()
		ghost_timer.start()
		hurtbox_component.monitoring = false
		hurtbox_component.monitorable = false
		dash_particles.emitting = true
		dash_direction = player.global_position - global_position
		dash_direction *= -1
	if dashing:
		velocity = dashing_component.accelerate_in_direction(dash_direction)
		move_and_slide()
	
func add_ghost():
	var ghost = ghost_scene.instantiate()
	ghost.set_property(global_position, animated_sprite_2d.scale)
	get_tree().current_scene.add_child(ghost)
	
func _dash_timeout():
	hurtbox_component.monitoring = true
	hurtbox_component.monitorable = true
	dashing = false
	dash_particles.emitting = false
	ghost_timer.stop()
	dash_cooldown.start()
	velocity = Vector2.ZERO
	
func _dash_cooldown():
	state = fire_state
	
func fire(): 
	if bow.is_playing():
		return
	shots_to_fire -=1
	bow.play("fire")
	await bow.animation_finished
	var projectile = ARROW_PROJECTILE.instantiate()
	var direction = player.global_position - global_position
	get_tree().current_scene.add_child(projectile)
	projectile.global_position = bow.global_position
	projectile.rotation = direction.angle()

func flip():
	var move_sign = sign((global_position.direction_to(player.global_position)).x)
	if(move_sign != 0):
		visuals.scale = Vector2(move_sign, 1)
		
	if move_sign == 0:
		move_sign = sign((get_global_mouse_position() - global_position).x)
		if(move_sign != 0):
			visuals.scale = Vector2(move_sign, 1)
