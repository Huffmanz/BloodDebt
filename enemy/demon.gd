class_name Demon
extends CharacterBody2D

@export var blood_cost : int = 10
@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	disable()

func enable():
	visible = true
	hitbox_component.monitorable = true
	hitbox_component.monitoring = true
	collision_shape_2d.disabled = false
	
func disable():
	visible = false
	hitbox_component.monitorable = false
	hitbox_component.monitoring = false
	collision_shape_2d.disabled = true
	
