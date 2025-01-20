class_name Enemy
extends CharacterBody2D

@onready var health_component: HealthComponent = $HealthComponent
@onready var item_drop_component: Node = $ItemDropComponent
@onready var velocity_component: VelocityComponent = $VelocityComponent
@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent
@onready var hitbox_component: HitboxComponent = $HitboxComponent


var dead := false

func _ready():
	health_component.died.connect(_died)
	item_drop_component.item_spawn_complete.connect(_items_spawned)
	
func _died():
	dead = true
	hurtbox_component.queue_free()
	hitbox_component.queue_free()
	velocity_component.max_speed = 0
	
	#queue_free()
	
func _items_spawned():
	queue_free()
