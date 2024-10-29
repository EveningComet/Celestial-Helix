## State where the player is controlling an active unit and not doing anything else.
class_name PBActive extends PBState

var _input_dir: Vector3

func enter(msgs: Dictionary = {}) -> void:
	match msgs:
		# The state entered with a player owned unit, so it's time to gain control
		{"unit": var new_unit}:
			_curr_unit = new_unit
	
	_curr_unit.finished_turn.connect( _on_unit_turn_finished )
	input_controller.use_skill_index.connect( _on_use_skill_at_index )

func exit() -> void:
	_input_dir = Vector3.ZERO
	_curr_unit.mover.set_input(_input_dir)
	_curr_unit.finished_turn.disconnect( _on_unit_turn_finished )
	input_controller.use_skill_index.disconnect( _on_use_skill_at_index )
	_curr_unit = null

func physics_update(delta: float) -> void:
	_get_input()
	_curr_unit.mover.set_input(_input_dir, input_controller.jump_pressed, input_controller.jump_released)
	var camera_dir = (camera_controller.global_transform.basis * Vector3.BACK).normalized()
	_curr_unit.mover.orient_to_direction(camera_dir, delta)
	
	# Keep track of how much the character has moved
	_curr_unit.update_amount_moved()

func _get_input() -> void:
	_input_dir = input_controller.input_dir
	
	# Change the input based on where the camera is looking
	var forward = camera_controller.basis.z
	var right   = camera_controller.basis.x
	_input_dir  = forward * _input_dir.z + right * _input_dir.x
	
	# Normalize the vector and allow for smooth controller input
	_input_dir = _input_dir.normalized() if _input_dir.length() > 1 else _input_dir

## When the player presses a skill, attempt to enter the skill targeting state.
func _on_use_skill_at_index(index: int) -> void:
	var skill_handler: SkillHandler  = _curr_unit.skill_handler
	var desired_skill: SkillInstance = skill_handler.get_skill_at_index(index)
	
	if desired_skill != null and _may_use_skill(desired_skill) == true:
		my_state_machine.change_to_state(
			"States/PBSkillTargeting",
			{"unit" = _curr_unit, "desired_skill" = desired_skill}
		)
