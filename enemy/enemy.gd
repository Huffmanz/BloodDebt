class_name Enemy
extends CharacterBody2D

@onready var health_component: HealthComponent = $HealthComponent
@onready var item_drop_component: Node = $ItemDropComponent

var dead := false

func _ready():
	health_component.died.connect(_died)
	item_drop_component.item_spawn_complete.connect(_items_spawned)
	
func _died():
	dead = true
	#queue_free()
	
func _items_spawned():
	queue_free()
