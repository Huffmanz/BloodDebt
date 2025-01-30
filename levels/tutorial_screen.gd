extends CanvasLayer
const DUMMY = preload("res://enemy/dummy.tscn")

@export var blood_hud: BloodHud

@onready var buttons: HBoxContainer = %Buttons
@onready var skip_tutorial: Button = %SkipTutorial
@onready var next_button: Button = %NextButton

@onready var welcome: PanelContainer = %Welcome
@onready var blood_explanation: PanelContainer = %BloodExplanation
@onready var debt_explanation: PanelContainer = %DebtExplanation
@onready var controls: PanelContainer = %Controls
@onready var dummy: PanelContainer = %Dummy
@onready var wave_complete: PanelContainer = %WaveComplete
@onready var end_tutorial: PanelContainer = %EndTutorial

@onready var cursor: Sprite2D = $"../Cursor"
@onready var spawn_loc: Marker2D = $"../SpawnLoc"

var current_item: CanvasItem
var next_pressed = 0

var tween : Tween

var blood_visible := false
var debt_visible := false
var blood_timer : SceneTreeTimer
var debt_timer: SceneTreeTimer

var dummy_dead := false
var is_wave_complete := false

func _ready()-> void:
	get_tree().paused = true

	skip_tutorial.pressed.connect(_skip_tutorial)
	next_button.pressed.connect(_next_pressed)
	
	current_item = welcome
	current_item.visible = true
	blood_explanation.visible = false
	debt_explanation.visible = false
	controls.visible = false
	dummy.visible = false
	wave_complete.visible = false
	end_tutorial.visible = false
	
	blood_hud.change_visibility_blood(false)
	blood_hud.change_visibility_debt(false)
	GameEvents.wave_start_next.connect(_wave_start)

func _process(delta: float) -> void:
	cursor.visible = !get_tree().paused
	if get_tree().paused:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	
	if next_pressed == 1:
		if not blood_timer:
			blood_timer = get_tree().create_timer(.5)
			blood_timer.timeout.connect(change_blood_visible)
	if next_pressed == 2:
		if not debt_timer:
			debt_timer = get_tree().create_timer(.5)
			debt_timer.timeout.connect(change_debt_visible)
	
	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
	
	if dummy_dead and entities_layer.get_child_count() == 1 and not is_wave_complete:
		is_wave_complete = true
		current_item = wave_complete
		current_item.visible = true
		get_tree().paused = true
		buttons.visible = true
		
func change_blood_visible():
	if next_pressed != 1:
		blood_hud.change_visibility_blood(false)
		return
	blood_visible = !blood_visible
	blood_hud.change_visibility_blood(blood_visible)
	blood_timer = get_tree().create_timer(.5)
	blood_timer.timeout.connect(change_blood_visible)
	
func change_debt_visible():
	if next_pressed != 2:
		blood_hud.change_visibility_blood(true)
		blood_hud.change_visibility_debt(true)
		return
	blood_visible = !blood_visible
	blood_hud.change_visibility_debt(blood_visible)
	blood_timer = get_tree().create_timer(.5)
	blood_timer.timeout.connect(change_debt_visible)

func _skip_tutorial() -> void:
	ScreenTransition.transition_to_scene("res://levels/world.tscn")
	
func _next_pressed() -> void:
	next_pressed += 1
	if current_item:
		current_item.visible = false
		
	if next_pressed == 1:
		current_item = blood_explanation
		current_item.visible = true
		blood_hud.change_visibility_blood(true)
		blood_visible = true
	if next_pressed == 2:
		current_item = debt_explanation
		current_item.visible = true
		blood_hud.change_visibility_blood(false)
		blood_hud.change_visibility_debt(true)
		debt_visible = true
	if next_pressed == 3:
		current_item = controls
		current_item.visible = true
	if next_pressed == 4:
		current_item = dummy
		current_item.visible = true
		var dummy_inst = DUMMY.instantiate() as Enemy
		get_tree().current_scene.add_child(dummy_inst)
		dummy_inst.global_position = spawn_loc.global_position
		dummy_inst.health_component.died.connect(_dummy_died)
	if next_pressed == 5:
		get_tree().paused = false
		buttons.visible = false
	if next_pressed == 6:
		get_tree().paused = false
		GameEvents.wave_complete.emit(1)
		buttons.visible = false
	if next_pressed == 7:
		_skip_tutorial()
		
func _dummy_died():
	dummy_dead = true
	
func _wave_start():
	current_item = end_tutorial
	current_item.visible = true
	buttons.visible = true
	get_tree().paused = true
		
