extends CharacterBody2D

@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var velocity_component: VelocityComponent = $VelocityComponent
@onready var delete_timer: Timer = $DeleteTimer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var impact_stream_player: AudioStreamPlayer2D = $ImpactStreamPlayer
@onready var shoot_stream_player: AudioStreamPlayer2D = $ShootStreamPlayer
@onready var environment_impact_player: AudioStreamPlayer2D = $EnvironmentImpactPlayer

func _ready():
	hitbox_component.area_entered.connect(on_area_entered)
	hitbox_component.body_entered.connect(on_body_entered)
	delete_timer.timeout.connect(_on_delete_timeout)
	shoot_stream_player.play_random()

func _physics_process(delta: float) -> void:
	velocity = velocity_component.accelerate_in_direction(global_transform.x)
	move_and_slide()

func on_area_entered(other_area:Node2D):
	set_physics_process(false)
	animated_sprite_2d.visible = false
	animated_sprite_2d.visible = false
	if not other_area is HurtboxComponent:
		environment_impact_player.play_random()
		await environment_impact_player.finished
		queue_free()
	else:
		impact_stream_player.play_random()
		await impact_stream_player.finished
		queue_free()
	
func on_body_entered(other_body):
	queue_free()
	
func _on_delete_timeout():
	queue_free()
