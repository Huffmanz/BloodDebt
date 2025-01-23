class_name Enemy
extends CharacterBody2D

@onready var health_component: HealthComponent = $HealthComponent
@onready var item_drop_component: ItemDropComponent = $ItemDropComponent
@onready var velocity_component: VelocityComponent = $VelocityComponent
@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent
@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var visuals: Node2D = $Visuals
var dead := false

func _ready():
	health_component.died.connect(_died)
	item_drop_component.item_spawn_complete.connect(_items_spawned)
	
func _died():
	dead = true
	item_drop_component.spawn_items()
	hurtbox_component.queue_free()
	hitbox_component.queue_free()
	velocity_component.max_speed = 0
	
	#queue_free()
	
func _items_spawned():
	queue_free()
	
func flip():
	var move_sign = sign(velocity.x)
	if(move_sign != 0):
		visuals.scale = Vector2(move_sign, 1)
		
	if move_sign == 0:
		move_sign = sign((get_global_mouse_position() - global_position).x)
		if(move_sign != 0):
			visuals.scale = Vector2(move_sign, 1)
