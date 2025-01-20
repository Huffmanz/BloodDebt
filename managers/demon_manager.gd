class_name DemonManager
extends Node

@export var demon: Demon
@onready var timer: Timer = $Timer

func _ready() -> void:
	GameEvents.wave_complete.connect(_wave_complete)
	timer.timeout.connect(_timer_timeout)
	demon.visible = false
	
func _wave_complete(wave_number: int) -> void:
	demon.visible = true
	demon.enable()
	timer.start()
	
func _timer_timeout():
	ScreenTransition.transition()
	await ScreenTransition.transitioned_halfway
	demon.disable()
	GameEvents.wave_start_next.emit()
