extends Node2D

@onready var start_button: Button = %StartButton
@onready var quit_button: Button = %QuitButton
@onready var cursor: Node2D = %Cursor
@onready var wave_time_manager: WaveManager = $WaveTimeManager
@onready var hitbox_component: HitboxComponent = %HitboxComponent


func _ready() -> void:
	start_button.pressed.connect(_start_button_pressed)
	quit_button.pressed.connect(_quit_button_pressed)
	wave_time_manager.timer.stop()
	wave_time_manager.timer.start(999)
	wave_time_manager.current_wave = 6
	wave_time_manager.wave_difficulty_increased.emit(wave_time_manager.current_wave)
	hitbox_component.monitorable = false
	hitbox_component.monitoring = false
	
func _process(delta: float) -> void:
	cursor.global_position = get_global_mouse_position()
	if Input.is_action_pressed("left_mouse"):
		hitbox_component.monitorable = true
		hitbox_component.monitoring = true
	else:
		hitbox_component.monitorable = false
		hitbox_component.monitoring = false
func _start_button_pressed():
	ScreenTransition.transition_to_scene("res://levels/world.tscn")
	
func _quit_button_pressed():
	get_tree().quit(0)
