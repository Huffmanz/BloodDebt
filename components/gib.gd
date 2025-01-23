class_name Gib
extends Node2D

@export var texture: Array[Texture2D]
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var bounce_component: BounceComponent = $BounceComponent
@onready var particle_timer: Timer = $Sprite2D/CPUParticles2D/ParticleTimer
@onready var cpu_particles_2d: CPUParticles2D = $Sprite2D/CPUParticles2D

var direction = Vector2.ZERO

func _ready() -> void:
	sprite_2d.texture = texture.pick_random()
	bounce_component.drop_height = randf_range(50,100)
	bounce_component.start()
	bounce_component.tween_completed.connect(on_tween_complete)
	direction.x = randf_range(-1, 1)
	direction.y = randf_range(-1, 1)
	particle_timer.timeout.connect(cpu_particles_2d.queue_free)

func _physics_process(delta):
	if direction != Vector2.ZERO:
		global_position += direction * delta * 300

func on_tween_complete():
	queue_free()
	direction = Vector2.ZERO
