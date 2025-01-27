extends Node

func _ready() -> void:
	GameEvents.wave_complete.connect(_on_wave_complete)


func _on_wave_complete(wave_number: int):
	get_parent().queue_free()
