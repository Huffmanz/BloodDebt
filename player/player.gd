extends CharacterBody2D

const PLAYER_PROJECTILE = preload("res://combat/player_projectile.tscn")

@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent
@onready var velocity_component: VelocityComponent = $VelocityComponent
@onready var attack_timer: Timer = $attack_timer

var direction := Vector2.ZERO
var can_shoot := true

func _ready() -> void:
	hurtbox_component.hit.connect(_hurtbox_hit)
	attack_timer.timeout.connect(_attack_timer_timeout)

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("left_mouse"):
		fire()
		
	direction.x = Input.get_axis("move_left", "move_right")
	direction.y = Input.get_axis("move_up", "move_down")
	
	velocity = velocity_component.accelerate_in_direction(direction)
	move_and_slide()

func fire():
	if !can_shoot:
		return
	var mouse_direction = get_global_mouse_position() - global_position
	var projectile : CharacterBody2D = PLAYER_PROJECTILE.instantiate()
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
	
