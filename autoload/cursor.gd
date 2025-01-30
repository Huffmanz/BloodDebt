extends Sprite2D

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	GameEvents.wave_started.connect(_on_wave_started)
	GameEvents.wave_complete.connect(_on_wave_complete)
	GameEvents.player_died.connect(_on_wave_complete)
	
func _process(delta: float) -> void:
	global_position = get_global_mouse_position()
	
func _on_wave_started(wave_number: int) -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	visible = true
	
func _on_wave_complete(wave_number: int) -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	visible = false
	
