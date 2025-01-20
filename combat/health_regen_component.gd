extends Node

@export var health_component: HealthComponent
@export var regen_amount: int
@onready var timer: Timer = $Timer

func _ready() -> void:
	timer.timeout.connect(_timer_timeout)
	
func _timer_timeout():
	health_component.heal(regen_amount)
