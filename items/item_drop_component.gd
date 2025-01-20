extends Node

@export_range(0, 1) var drop_percent: float =  .5
@export var health_component: HealthComponent
@export var item_scene: PackedScene

func _ready() -> void:
	health_component.died.connect(_on_died)


func _on_died() -> void:
	var adjusted_drop_percent = drop_percent
	#var experience_gain_upgrade_count = MetaProgression.get_upgrade_count("experience_gain")
	#if experience_gain_upgrade_count > 0:
	#	adjusted_drop_percent += experience_gain_upgrade_count * .1
		
	if randf() > adjusted_drop_percent:
		return
		
	if item_scene == null:
		return
	
	if not owner is Node2D:
		return
		
	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
	var spawn_position = (owner as Node2D).global_position
	var item_instance = item_scene.instantiate() as Node2D
	if entities_layer == null:
		return
	get_tree().current_scene.add_child(item_instance)
	item_instance.global_position = spawn_position
