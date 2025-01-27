class_name BloodDebtManager
extends Node

@export var blood_debt_upgrades: Array[BloodDebtUpgrade]
@export var blood_debt_menu: PackedScene
@export var starting_blood_debt: int
@export_range(0,1) var debt_growth_rate: float
@export var wave_multiplier: float = 1.2

@onready var timer: Timer = $Timer
@onready var wave_time_label: Label = %WaveTimeLabel
@onready var canvas_layer: CanvasLayer = $CanvasLayer

var current_blood := 0
var current_blood_debt := 0
var debt_multiplier := 1

func _ready() -> void:
	GameEvents.wave_complete.connect(_wave_complete)
	GameEvents.wave_started.connect(_wave_started)
	GameEvents.player_health_updated.connect(_player_health_updated)
	
	GameEvents.blood_debt_effect_multiplier.connect(_blood_debt_multiplier)
	GameEvents.blood_debt_effect_reduce.connect(_reduce_blood_debt)
	timer.timeout.connect(_timer_timeout)
	canvas_layer.visible = false
	current_blood_debt = starting_blood_debt
	
func _process(delta: float) -> void:
	var time_elapsed = timer.time_left
	wave_time_label.text = format_seconds_to_string(time_elapsed)
	
func _player_health_updated(amount: int):
	current_blood = amount
	
func _wave_started(wave_number: int) -> void:
	current_blood_debt = starting_blood_debt * (1+debt_growth_rate)**wave_number + (wave_multiplier * wave_number)
	current_blood_debt *= debt_multiplier
	GameEvents.blood_debt_updated.emit(current_blood_debt)
	
func _wave_complete(wave_number: int) -> void:
	debt_multiplier = 1
	var menu_instance = blood_debt_menu.instantiate() as BloodDebtMenu
	add_child(menu_instance)
	menu_instance.pay_debt.connect(_pay_debt)
	GameEvents.blood_debt_updated.emit(current_blood_debt)
	menu_instance.set_ability_upgrades(pick_upgrades())
	
func pick_upgrades() -> Array[BloodDebtUpgrade]:
	var upgrade_pool: Array[BloodDebtUpgrade] = blood_debt_upgrades.duplicate()
	var chosen_upgrades: Array[BloodDebtUpgrade] = []
	for i in 2:
		var chosen_upgrade = upgrade_pool.pick_random()
		upgrade_pool.erase(chosen_upgrade)
		chosen_upgrades.append(chosen_upgrade)
	return chosen_upgrades
		
		
func _blood_debt_multiplier(amount: int):
	debt_multiplier = amount
		
func _reduce_blood_debt(percent: float):
	current_blood_debt = current_blood_debt - (current_blood_debt * percent)
	GameEvents.blood_debt_updated.emit(current_blood_debt)
	
func _pay_debt():
	GameEvents.player_remove_blood.emit(current_blood_debt)
	ScreenTransition.transition()
	await ScreenTransition.transitioned_halfway
	timer.start()
	canvas_layer.visible = true
	
func _timer_timeout():
	get_tree().paused = false
	canvas_layer.visible = false
	GameEvents.wave_start_next.emit()
	
	
func format_seconds_to_string(seconds: float):
	var minutes = floor(seconds / 60)
	var remaining_seconds = seconds - (minutes * 60)
	return str(minutes) + ":" + ("%02d" % floor(remaining_seconds))
