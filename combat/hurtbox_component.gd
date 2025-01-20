extends Area2D
class_name HurtboxComponent

signal hit

@export var health_component: HealthComponent
var floating_text_scene = preload("res://ui/floating_text.tscn")

func _ready():
	area_entered.connect(on_area_entered)
	
func on_area_entered(other_area:Area2D):
	if not other_area is HitboxComponent:
		return
		
	if health_component == null:
		return	
		
	var hitbox_component = other_area as HitboxComponent
	health_component.damage(hitbox_component.damage)
	#GameEvents.frameFreeze(0.1, 0.3)
	create_damage_numbers(hitbox_component.damage)
	hit.emit()
	
	
func create_damage_numbers(damage: float):
	var floating_text = floating_text_scene.instantiate() as Node2D
	get_tree().get_first_node_in_group("foreground_layer").add_child(floating_text)
	floating_text.global_position = global_position + (Vector2.UP * 16)
	var format_screen = "%0.0f"
	floating_text.start(format_screen % damage)
