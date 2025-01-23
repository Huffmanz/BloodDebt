class_name Player
extends CharacterBody2D

const PLAYER_PROJECTILE = preload("res://combat/player_projectile.tscn")

@onready var velocity_component: VelocityComponent = $VelocityComponent
@onready var dashing_component: VelocityComponent = $DashingComponent
@onready var health_component: HealthComponent = $HealthComponent
@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent
@onready var attack_timer: Timer = $attack_timer
@onready var dash_timer: Timer = $DashingComponent/DashTimer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var direction := Vector2.ZERO
var can_shoot := true
var dashing := false
var dash_direction:=Vector2.ZERO
var spawn_position = Vector2.ZERO

func _ready() -> void:
	health_component.died.connect(on_died)
	hurtbox_component.hit.connect(_hurtbox_hit)
	attack_timer.timeout.connect(_attack_timer_timeout)
	GameEvents.player_blood_gained.connect(_player_blood_gained)
	health_component.health_changed.connect(_player_health_changed)
	dash_timer.timeout.connect(_dash_timeout)
	spawn_position = global_position

func _physics_process(delta: float) -> void:
	direction.x = Input.get_axis("move_left", "move_right")
	direction.y = Input.get_axis("move_up", "move_down")
	if Input.is_action_pressed("left_mouse"):
		fire()
	if Input.is_action_just_pressed("dash"):
		dashing = true
		dash_timer.start()
		dash_direction = direction
		
	if dashing:
		velocity = dashing_component.accelerate_in_direction(dash_direction)
	else:
		velocity = velocity_component.accelerate_in_direction(direction)
	
	if direction == Vector2.ZERO:
		animated_sprite_2d.play("idle")
	else:
		animated_sprite_2d.play("run")
	flip()
	move_and_slide()

func flip():
	var move_sign = sign(direction.x)
	if(move_sign != 0):
		animated_sprite_2d.scale = Vector2(move_sign, 1)
		
	if move_sign == 0:
		move_sign = sign((get_global_mouse_position() - global_position).x)
		if(move_sign != 0):
			animated_sprite_2d.scale = Vector2(move_sign, 1)

func fire():
	if !can_shoot:
		return
	var mouse_direction = get_global_mouse_position() - global_position
	var projectile : CharacterBody2D = PLAYER_PROJECTILE.instantiate()
	health_component.reduce_health(1)
	get_tree().current_scene.add_child(projectile)
	projectile.global_position = global_position
	projectile.rotation = mouse_direction.angle()
	can_shoot = false
	attack_timer.start()
	
func _hurtbox_hit():
	GameEvents.frameFreeze(0.1, 0.3)
	GameEvents.emit_camera_shake(5)
	
func _attack_timer_timeout():
	can_shoot = true
	
func _player_blood_gained(amount: int):
	health_component.heal(amount)
	
func _player_health_changed():
	GameEvents.emit_player_health_updated(health_component.current_health)
	print(health_component.current_health)
	
func _dash_timeout():
	dashing = false
	
func reset_location():
	global_position = spawn_position
	
func on_died():
	print("DEAD")
