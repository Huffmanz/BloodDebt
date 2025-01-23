extends CanvasLayer

@onready var blood_text: Label = $MarginContainer/BloodText


func _ready() -> void:
	GameEvents.player_health_updated.connect(_player_health_updated)
	
	
func _player_health_updated(amount: int) -> void:
	update_blood_text(amount)
	
func update_blood_text(amount: int) -> void:
	blood_text.text = str(amount)
	
