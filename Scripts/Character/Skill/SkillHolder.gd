## Stores the skills for a character.
class_name SkillHolder extends Resource

## The stored character skills.
@export var _skills: Array[SkillInstance] = []

## Get all the non-passive skills.
func get_activatable__skills() -> Array[SkillInstance]:
	var to_return: Array[SkillInstance] = []
	for si: SkillInstance in _skills:
		if si.skill.is_passive == false:
			to_return.append(si)
	return to_return
