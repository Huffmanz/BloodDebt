class_name BloodDebtMenu
extends CanvasLayer

signal pay_debt

@export var upgrade_card_scene: PackedScene

@onready var card_container: HBoxContainer = %CardContainer
@onready var pay_debt_button: Button = %PayDebtButton	
@onready var blood_debt_amount: Label = %BloodDebtAmount
@onready var blood_debt_shaker: Shaker = %BloodDebtShaker

func _ready():
	GameEvents.blood_debt_updated.connect(_blood_debt_updated)
	pay_debt_button.pressed.connect(_pay_debt_button)
	get_tree().paused = true
	
func set_ability_upgrades(upgrades: Array[BloodDebtUpgrade]):
	var delay = 0
	for upgrade in upgrades:
		var card_instance = (upgrade_card_scene.instantiate()) as BloodDebtCard
		card_container.add_child(card_instance)
		card_instance.set_ability_upgrade(upgrade)
		card_instance.play_in(delay)
		#card_instance.selected.connect(on_upgrade_selected.bind(upgrade))
		delay += .2
		
func _pay_debt_button():
	#get_tree().paused = false
	pay_debt.emit()
	queue_free()
	
func _blood_debt_updated(amount:int):
	blood_debt_shaker.start(.25)
	blood_debt_amount.text = str(amount)
