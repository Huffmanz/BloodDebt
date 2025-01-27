extends Resource
class_name BloodDebtUpgrade

@export var id: String
@export var name: String
@export var effects : Array[EffectBase] = []
var description: String

func get_description() -> String:
	description = ""
	for effect in effects:
		description += effect.get_description() + "  "
	return description
