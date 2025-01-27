class_name Item
extends Node2D

@onready var pickup_area: Area2D = $PickupArea
@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $PickupArea/CollisionShape2D
@onready var bounce_component: BounceComponent = $BounceComponent
@onready var collect_stream_player: AudioStreamPlayer2D = $CollectStreamPlayer

var direction = Vector2.ZERO
var wave_complete := false
var start_collect := false

func _ready():
	pickup_area.area_entered.connect(on_area_entered)
	bounce_component.start()
	bounce_component.tween_completed.connect(_tween_complete)
	direction.x = randf_range(-20, 20)
	direction.y = randf_range(10, 20)
	GameEvents.wave_complete.connect(_wave_complete)
	
func _physics_process(delta):
	if direction != Vector2.ZERO:
		global_position += direction * delta
	if wave_complete && start_collect:
		var player = get_tree().get_first_node_in_group("player")
		if player == null:
			return
		
		start_collect = false
		var distance = global_position.distance_to(player.global_position)
		var duration = min(abs((distance * 0.005)),2)
		start_collect_tween(duration)
		
func _wave_complete(amount: int):
	wave_complete = true
	start_collect = true
	
func _wave_started():
	wave_complete = false
	start_collect = false
	
func tween_collect(percent: float, start_position: Vector2):
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		return
		
	global_position = start_position.lerp(player.global_position, percent)
	var direction_from_start = player.global_position - start_position
	var target_rotation = direction_from_start.angle() + deg_to_rad(90)
	rotation = lerp_angle(rotation, target_rotation, 1-exp(-2 * get_process_delta_time()))
	
func collect():
	collect_stream_player.play_random()
	Utils.create_positive_numbers(global_position + (Vector2.UP * 16), 1)
	await collect_stream_player.finished
	GameEvents.emit_player_blood_gained(1)
	queue_free()

func disable_collision():
	collision_shape_2d.disabled =  true
	
func on_area_entered(other_area: Area2D):
	Callable(disable_collision).call_deferred()
	start_collect_tween(.5)
	
func start_collect_tween(duration: float):
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_method(tween_collect.bind(global_position), 0.0, 1.0, duration)\
		.set_ease(Tween.EASE_IN)\
		.set_trans(Tween.TRANS_BACK)
	tween.tween_property(sprite, "scale", Vector2.ZERO, .05).set_delay(duration-0.05)
	tween.chain() #finish other tweens first
	tween.tween_callback(collect)
	
func _tween_complete():
	pickup_area.monitorable = true
	pickup_area.monitoring = true
	direction = Vector2.ZERO
