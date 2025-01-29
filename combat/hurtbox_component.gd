extends Area2D
class_name HurtboxComponent

signal hit

@export var health_component: HealthComponent
@export var multiplier : float = 1
var floating_text_scene = preload("res://ui/floating_text.tscn")

func _ready():
	area_entered.connect(on_area_entered)
	
func on_area_entered(other_area:Area2D):
	if not other_area is HitboxComponent:
		return
		
	if health_component == null:
		return
		
	var hitbox_component = other_area as HitboxComponent
	var damage = ceil(hitbox_component.damage * multiplier)
	health_component.damage(damage)
	Utils.create_negative_numbers(global_position + (Vector2.UP * 16), damage)
	hit.emit()
	
	
