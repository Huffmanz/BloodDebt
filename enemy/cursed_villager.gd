extends Enemy


func _ready() -> void:
	super._ready()


func _physics_process(delta: float) -> void:
	velocity = velocity_component.accelerate_to_player()
	move_and_slide()
