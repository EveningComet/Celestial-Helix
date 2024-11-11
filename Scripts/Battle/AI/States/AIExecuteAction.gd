## State for when the AI has passed all needed checks and may execute their action.
class_name AIExecuteAction extends AIState

func enter(msgs: Dictionary = {}) -> void:
	_determine_resolution()

func _determine_resolution() -> void:
	await my_state_machine.get_tree().create_timer(1.0, false, false).timeout
	var skill_data: SkillData = _curr_action.skill.skill
	var targeting_data: TargetingData = _get_targeting_data(skill_data.targeting_range)
	targeting_data.targets = TargetingUtils.get_aoe(skill_data.targeting_aoe)
	
	# Everything is good, execute the action
	skill_data.execute(targeting_data)
	await skill_data.skill_executed
	
	# Nothing else to do. End the turn
	_unit.finished_turn.emit(_unit)
	my_state_machine.change_to_state("AIWaiting")

func _get_targeting_data(t_range: TargetingRange) -> TargetingData:
	if t_range is TRDirection:
		return (t_range as TRDirection).get_targeting_data(
			_unit,
			-(_unit.global_position - _curr_action.target_unit.global_position).normalized()
		)
	return null
