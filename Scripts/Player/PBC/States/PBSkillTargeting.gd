## This state is used when the player is actively finding a target for a skill.
class_name PBSkillTargeting extends PBState

## Reference of the skill the player wants to use.
var _desired_skill: SkillInstance

## Used to prevent activating a skill more than once.
var _skill_already_executed: bool = false

func enter(msgs: Dictionary = {}) -> void:
	match msgs:
		{"unit": var new_unit, "desired_skill": var new_skill}:
			_curr_unit     = new_unit
			_desired_skill = new_skill
	
	# TODO: Activate things such as target highlighters and so on.
	
	_input_controller.use_skill_index.connect( _on_skill_usage_confirmed )
	_input_controller.cancel_skill_usage.connect( _on_skill_targeting_canceled )

func exit() -> void:
	_input_controller.use_skill_index.disconnect( _on_skill_usage_confirmed )
	_input_controller.cancel_skill_usage.disconnect( _on_skill_targeting_canceled )
	_desired_skill = null
	_curr_unit     = null
	_skill_already_executed = false

func physics_update(delta: float) -> void:
	var camera_dir = (_camera_controller.global_transform.basis * Vector3.BACK).normalized()
	_curr_unit.mover.orient_to_direction(
		camera_dir, delta
	)

## Execute the skill when this method is called.
func _on_skill_usage_confirmed(index: int) -> void:
	if _skill_already_executed == true:
		return
	
	# Create the targeting data and get the needed information
	var targeting_data: TargetingData = TargetingData.new()
	targeting_data.activator = _curr_unit
	targeting_data.origin    = _curr_unit.global_position + Vector3.UP
	targeting_data.direction = (_camera_controller.get_aim_target() - targeting_data.origin).normalized()
	
	# Finally, execute the skill
	_desired_skill.skill.skill_executed.connect( _on_skill_executed )
	_curr_unit.skill_handler.execute_skill(_desired_skill, targeting_data)
	_skill_already_executed = true

## Should be called after a skill has been finished.
func _on_skill_executed() -> void:
	_desired_skill.skill.skill_executed.disconnect( _on_skill_executed )
	if _curr_unit.curr_action_points > 0:
		my_state_machine.change_to_state("States/PBActive", {"unit" = _curr_unit})
	else:
		my_state_machine.change_to_state("States/PBWaiting")

## Back out of the state if the player declines.
func _on_skill_targeting_canceled() -> void:
	my_state_machine.change_to_state("States/PBActive", {"unit" = _curr_unit})
