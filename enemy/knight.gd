extends Enemy

@onready var animated_sprite_2d: AnimatedSprite2D = $Visuals/AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _physics_process(delta: float) -> void:
	if dead:
		return
	velocity = velocity_component.accelerate_to_player()
	flip()
	move_and_slide()
