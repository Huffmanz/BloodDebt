extends Enemy

@onready var animated_sprite_2d: AnimatedSprite2D = $Visuals/AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var state_timer: Timer = $StateTimer
@onready var weapon_visuals: Node2D = $Visuals/WeaponVisuals
@onready var shield_visuals: Node2D = $Visuals/ShieldVisuals
@onready var sheild_area: Area2D = $Visuals/ShieldVisuals/Shield/Area2D

var knight_gib_component = preload("res://components/gib_component/knight_gib_component.tscn")

var STATE_OPTIONS = [move_state, block_state]
var state = block_state : set = set_state
var state_init = true : get = get_state_init

func set_state(value):
	state = value
	state_init = true
	
func get_state_init():
	var was = state_init
	state_init = false
	return was
	
func _init() -> void:
	gib_component = knight_gib_component
	state = STATE_OPTIONS.pick_random()

func _physics_process(delta: float) -> void:
	if dead:
		state_timer.stop()
		return
	state.call(delta)

func move_state(delta: float):
	if state_init:
		state_timer.start(randf_range(4.0, 6.0))
		state_timer.timeout.connect(set_state.bind(block_state), CONNECT_ONE_SHOT)		
		animation_player.play("spin")
		animated_sprite_2d.play("default")
		shield_visuals.visible = false
		sheild_area.monitorable = false 
		sheild_area.monitoring = false
	velocity = velocity_component.accelerate_to_player()
	flip()
	move_and_slide()
	
func block_state(delta: float):
	if state_init:
		state_timer.start(randf_range(4.0, 6.0))
		state_timer.timeout.connect(set_state.bind(move_state), CONNECT_ONE_SHOT)
		animation_player.play("block")
		animated_sprite_2d.play("idle")
		shield_visuals.visible = true
		sheild_area.monitorable = true 
		sheild_area.monitoring = true
		flip()
	#var player = get_tree().get_first_node_in_group("player") as Node2D
	#shield_visuals.look_at(player.global_position)
	
	#var direction = shield_visuals.global_position- player.global_position
	#var vertical_sign = sign(direction.y)
	#if(vertical_sign != 0):
	#	shield_visuals.scale = Vector2(1, vertical_sign)
		


func _pick_state():
	state = STATE_OPTIONS.pick_random()
		
