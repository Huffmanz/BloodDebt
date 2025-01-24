extends Node
class_name BounceComponent

@export var host_node: Node2D
@export var drop_height = 20
@export var start_at_top = true
@export var single_use = true
@export var rotate = false
const TWEEN_DURATION = 0.1
const RECOVERY_FACTOR = 0.5

signal tween_completed

func start():
	if start_at_top:
		var drop_tween = drop_down(drop_height)
		await drop_tween.finished
		drop_tween.kill()
		
	var bounce_height = drop_height * RECOVERY_FACTOR
	while bounce_height > 1:
		var bounce_tween = _bounce_up(bounce_height)
		await bounce_tween.finished
		bounce_tween.kill()
		
		var drop_tween = drop_down(bounce_height)
		await drop_tween.finished
		drop_tween.kill()
		bounce_height = bounce_height * RECOVERY_FACTOR
	tween_completed.emit()	
	if single_use:
		queue_free()
	
func _bounce_up(height) -> Tween:
	var y_end = -height
	var tween: Tween = create_tween()
	
	tween.tween_property(host_node, "position:y", y_end, TWEEN_DURATION)\
		.set_ease(Tween.EASE_OUT)\
		.set_trans(Tween.TRANS_CUBIC)
	if rotate:
		tween.tween_property(host_node, "rotation_degrees", randf_range(-30, -45), TWEEN_DURATION)\
			.set_ease(Tween.EASE_OUT)\
			.set_trans(Tween.TRANS_CUBIC)

	return tween

func drop_down(height) -> Tween:
	var y_end = -height
	var tween: Tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(host_node, "position:y", 0, TWEEN_DURATION)\
		.set_ease(Tween.EASE_OUT)\
		.set_trans(Tween.TRANS_CUBIC)
	if rotate:
		tween.tween_property(host_node, "rotation_degrees", randf_range(30, 45), TWEEN_DURATION)\
			.set_ease(Tween.EASE_OUT)\
			.set_trans(Tween.TRANS_CUBIC)
	
	return tween
