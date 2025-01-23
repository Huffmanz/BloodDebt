extends Enemy

@onready var visuals: Node2D = $Visuals
@onready var animated_sprite_2d: AnimatedSprite2D = $Visuals/AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

const GIB_COMPONENT = preload("res://components/knight_gib_component.tscn")
func _ready() -> void:
	super._ready()


func _physics_process(delta: float) -> void:
	if dead:
		return
	velocity = velocity_component.accelerate_to_player()
	flip()
	move_and_slide()

func _died():
	dead = true
	hurtbox_component.queue_free()
	hitbox_component.queue_free()
	velocity_component.max_speed = 0
	
	var gib_instance = GIB_COMPONENT.instantiate() as GibComponent
	gib_instance.global_position = global_position
	get_tree().current_scene.add_child(gib_instance)
	
	#animated_sprite_2d.play("death")
	#animation_player.play("death")
	visuals.queue_free()
	#await animated_sprite_2d.animation_finished
	item_drop_component.spawn_items()
	

func flip():
	var move_sign = sign(velocity.x)
	if(move_sign != 0):
		visuals.scale = Vector2(move_sign, 1)
		
	if move_sign == 0:
		move_sign = sign((get_global_mouse_position() - global_position).x)
		if(move_sign != 0):
			visuals.scale = Vector2(move_sign, 1)
