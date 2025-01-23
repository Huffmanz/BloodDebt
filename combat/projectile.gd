extends CharacterBody2D

@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var velocity_component: VelocityComponent = $VelocityComponent
@onready var delete_timer: Timer = $DeleteTimer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	hitbox_component.area_entered.connect(on_area_entered)
	hitbox_component.body_entered.connect(on_body_entered)
	delete_timer.timeout.connect(_on_delete_timeout)

func _physics_process(delta: float) -> void:
	velocity = velocity_component.accelerate_in_direction(global_transform.x)
	move_and_slide()

func on_area_entered(other_area:Node2D):
	if not other_area is HurtboxComponent:
		return 
	set_physics_process(false)
	animated_sprite_2d.visible = false
	queue_free()
	
func on_body_entered(other_body):
	queue_free()
	
func _on_delete_timeout():
	queue_free()
