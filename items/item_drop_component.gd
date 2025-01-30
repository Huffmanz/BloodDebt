class_name  ItemDropComponent
extends Node

@export_range(0, 1) var drop_percent: float =  .5
@export var item_scenes: Array[PackedScene]

signal item_spawn_complete

func spawn_items() -> void:
	var adjusted_drop_percent = drop_percent
	#var experience_gain_upgrade_count = MetaProgression.get_upgrade_count("experience_gain")
	#if experience_gain_upgrade_count > 0:
	#	adjusted_drop_percent += experience_gain_upgrade_count * .1
			
	if item_scenes == null:
		return
	
	if not owner is Node2D:
		return
	
	for item_scene in item_scenes:
		if randf() > adjusted_drop_percent:
			continue
			
		spawn_item(item_scene) 
		await get_tree().create_timer(.25).timeout
	item_spawn_complete.emit()

	
func spawn_item(item:PackedScene):
	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
	var spawn_position = (owner as Node2D).global_position
	var item_instance = item.instantiate() as Node2D
	if entities_layer == null:
		return
	entities_layer.add_child(item_instance)
	item_instance.global_position = spawn_position + (Vector2(randf_range(-10.0, 10.0), randf_range(-10.0, -10.0)))
	
