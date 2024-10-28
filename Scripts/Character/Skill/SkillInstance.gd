## Stores an instance of a skill.
class_name SkillInstance extends Resource

@export var skill: SkillData = null

var _turns_left_until_usable_again: int = 0:
	get: return _turns_left_until_usable_again
	set(value):
		_turns_left_until_usable_again = value
		_turns_left_until_usable_again = clamp(_turns_left_until_usable_again, 0, value)

## Lower the count for this instance.
func tick() -> void:
	_turns_left_until_usable_again -= 1

func is_cooldown_finished() -> bool:
	return _turns_left_until_usable_again == 0

## Return the final ap cost for using this skill.
func get_ap_cost() -> int:
	return skill.base_ap_cost
