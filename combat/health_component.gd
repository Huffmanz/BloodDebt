extends Node
class_name HealthComponent

signal died
signal health_changed
signal health_decreased(amount: int)

@export var max_health: float = 10
var current_health 

func _ready():
	current_health = max_health 

func damage(damage_amount: float):
	reduce_health(damage_amount)
	if damage_amount > 0:
		health_decreased.emit(damage_amount)
		
func reduce_health(amount: float):
	current_health = clamp(current_health-amount, 0, max_health)
	health_changed.emit()
	Callable(check_death).call_deferred()
	
func heal(heal_amount: float):
	max_health += heal_amount
	#current_health = clamp(current_health+heal_amount, 0, max_health)
	current_health = current_health+heal_amount
	health_changed.emit()
	
func get_health_percent():
	if max_health <= 0:
		return 0
	return min(current_health / max_health, 1)
	
func check_death():
	if current_health == 0:
		died.emit()
