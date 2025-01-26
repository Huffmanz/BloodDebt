class_name  GibComponent
extends Node2D

@export var gibs: Array[PackedScene]
@onready var cpu_particles_2d: CPUParticles2D = $CPUParticles2D
@onready var timer: Timer = $Timer
@onready var random_stream_player: AudioStreamPlayer2D = $RandomStreamPlayer

func _ready() -> void:
	timer.timeout.connect(queue_free)
	for gib in gibs:
		var instance = gib.instantiate() as Gib
		instance.global_position = global_position
		get_tree().current_scene.add_child(instance)
	cpu_particles_2d.emitting = true
	random_stream_player.play_random()
