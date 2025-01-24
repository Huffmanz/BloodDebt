class_name Enemy
extends CharacterBody2D

@onready var health_component: HealthComponent = $HealthComponent
@onready var item_drop_component: ItemDropComponent = $ItemDropComponent
@onready var velocity_component: VelocityComponent = $VelocityComponent
@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent
@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var visuals: Node2D = $Visuals

var dead := false
var gib_component = preload("res://components/gib_component/knight_gib_component.tscn")

func _init() -> void:
	pass

func _ready():
	_init()
	health_component.died.connect(_died)
	item_drop_component.item_spawn_complete.connect(_items_spawned)
	
func _died():
	dead = true
	item_drop_component.spawn_items()
	hurtbox_component.queue_free()
	hitbox_component.queue_free()
	velocity_component.max_speed = 0
	
	var gib_instance = gib_component.instantiate()
	gib_instance.global_position = global_position
	get_tree().current_scene.add_child(gib_instance)
	
	visuals.queue_free()
	item_drop_component.spawn_items()
	GameEvents.camera_shake
	GameEvents.frameFreeze(0.1, 0.3)
	GameEvents.emit_camera_shake(5)

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
