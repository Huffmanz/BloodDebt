extends Node
class_name  VelocityComponent

@export var max_speed: int = 40
@export var acceleration: float = 5

var velocity = Vector2.ZERO

func accelerate_in_direction(direction: Vector2) -> Vector2:
	direction = direction.normalized()
	var desired_velocity = direction * max_speed
	velocity = velocity.lerp(desired_velocity, 1 - exp(-acceleration * get_process_delta_time()))
	return velocity

func decelerate() -> Vector2:
	return accelerate_in_direction(Vector2.ZERO)
