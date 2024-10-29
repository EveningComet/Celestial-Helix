## This state is used when the player is actively finding a target for a skill.
class_name PBSkillTargeting extends PBState

## Reference of the skill the player wants to use.
var _desired_skill: SkillInstance

func enter(msgs: Dictionary = {}) -> void:
	match msgs:
		{"unit": var new_unit, "desired_skill": var new_skill}:
			_curr_unit     = new_unit
			_desired_skill = new_skill
	
	# TODO: Activate things such as target highlighters and so on.
	
	input_controller.use_skill_index.connect( _on_skill_usage_confirmed )
	input_controller.cancel_skill_usage.connect( _on_skill_targeting_canceled )

func exit() -> void:
	input_controller.use_skill_index.disconnect( _on_skill_usage_confirmed )
	input_controller.cancel_skill_usage.disconnect( _on_skill_targeting_canceled )
	_desired_skill = null
	_curr_unit     = null

func physics_update(delta: float) -> void:
	var camera_dir = (camera_controller.global_transform.basis * Vector3.BACK).normalized()
	_curr_unit.mover.orient_to_direction(
		camera_dir, delta
	)

## Execute the skill when this method is called.
func _on_skill_usage_confirmed(index: int) -> void:
	_curr_unit.skill_handler.execute_skill(_desired_skill)
	if _curr_unit.curr_action_points > 0:
		my_state_machine.change_to_state("States/PBActive", {"unit" = _curr_unit})
	else:
		my_state_machine.change_to_state("States/PBWaiting")

## Back out of the state if the player declines.
func _on_skill_targeting_canceled() -> void:
	my_state_machine.change_to_state("States/PBActive", {"unit" = _curr_unit})
