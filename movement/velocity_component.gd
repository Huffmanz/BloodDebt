extends Node
class_name  VelocityComponent

@export var max_speed: int = 40
@export var acceleration: float = 5

var velocity = Vector2.ZERO
var player : Node2D

func accelerate_to_player() -> Vector2:
	var owner_node2d = owner as Node2D
	if owner_node2d == null:
		return Vector2.ZERO
		
	if player == null:
		player = get_tree().get_first_node_in_group("player") as Node2D
	
	var direction = (player.global_position - owner_node2d.global_position).normalized()
	return accelerate_in_direction(direction)

func accelerate_in_direction(direction: Vector2) -> Vector2:
	direction = direction.normalized()
	var desired_velocity = direction * max_speed
	velocity = velocity.lerp(desired_velocity, 1 - exp(-acceleration * get_process_delta_time()))
	return velocity

func decelerate() -> Vector2:
	return accelerate_in_direction(Vector2.ZERO)
