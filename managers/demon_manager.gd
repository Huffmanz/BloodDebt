class_name DemonManager
extends Node

@export var demon: Demon
@onready var timer: Timer = $Timer
@onready var wave_time_label: Label = %WaveTimeLabel
@onready var canvas_layer: CanvasLayer = $CanvasLayer


func _ready() -> void:
	GameEvents.wave_complete.connect(_wave_complete)
	timer.timeout.connect(_timer_timeout)
	demon.visible = false
	canvas_layer.visible = false
	
func _process(delta: float) -> void:
	var time_elapsed = timer.time_left
	wave_time_label.text = format_seconds_to_string(time_elapsed)
	
func _wave_complete(wave_number: int) -> void:
	demon.visible = true
	canvas_layer.visible = true
	demon.enable()
	timer.start()
	
func _timer_timeout():
	ScreenTransition.transition()
	await ScreenTransition.transitioned_halfway
	demon.disable()
	GameEvents.wave_start_next.emit()
	canvas_layer.visible = false
	
func format_seconds_to_string(seconds: float):
	var minutes = floor(seconds / 60)
	var remaining_seconds = seconds - (minutes * 60)
	return str(minutes) + ":" + ("%02d" % floor(remaining_seconds))
