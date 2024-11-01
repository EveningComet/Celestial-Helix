## Stores the skills for a character.
class_name SkillHandler extends Node

## Fired when a skill is executed.
signal skill_executed(skill_instance: SkillInstance)

## The stored character skills.
@export var _skills: Array[SkillInstance] = []

@onready var combatant: Combatant = get_parent().get_node("Combatant")

## Attempt to use a skill at the passed index.
func use_skill_at_index(index: int, targeting_data: TargetingData) -> void:
	var si = get_skill_at_index(index)
	if si != null:
		execute_skill(_skills[index], targeting_data)

## Fire the skill.
func execute_skill(si: SkillInstance, targeting_data: TargetingData) -> void:
	si.skill.execute(targeting_data)
	skill_executed.emit(si)

func get_skill_at_index(index: int) -> SkillInstance:
	return _skills[index] if index <= _skills.size() - 1 else null 

## Get all the non-passive skills.
func get_activatable_skills() -> Array[SkillInstance]:
	var to_return: Array[SkillInstance] = []
	for si: SkillInstance in _skills:
		if si.skill.is_passive == false:
			to_return.append(si)
	return to_return
