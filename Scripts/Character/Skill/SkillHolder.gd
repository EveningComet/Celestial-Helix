## Stores the skills for a character.
class_name SkillHolder extends Resource

## The stored character skills.
@export var _skills: Array[SkillInstance] = []

var combatant: Combatant

func _init(_com: Combatant = null) -> void:
	combatant = _com

## Get all the non-passive skills.
func get_activatable_skills() -> Array[SkillInstance]:
	var to_return: Array[SkillInstance] = []
	for si: SkillInstance in _skills:
		if si.skill.is_passive == false:
			to_return.append(si)
	return to_return
