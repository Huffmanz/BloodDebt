extends CharacterBody2D

@export var max_speed : int = 40
@export var acceleration: float = 5


var direction = Vector2.ZERO
@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent

func _ready() -> void:
	hurtbox_component.hit.connect(_hurtbox_hit)

func _physics_process(delta: float) -> void:
	direction.x = Input.get_axis("move_left", "move_right")
	direction.y = Input.get_axis("move_up", "move_down")
	direction = direction.normalized()
	var desired_velocity = direction * max_speed
	velocity = velocity.lerp(desired_velocity, 1 - exp(-acceleration * get_process_delta_time()))
	move_and_slide()

func _hurtbox_hit():
	GameEvents.frameFreeze(0.1, 0.3)
	GameEvents.emit_camera_shake(5)
