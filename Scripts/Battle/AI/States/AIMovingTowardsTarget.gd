class_name AIMovingTowardsTarget extends AIState

var _nav_agent: NavigationAgent3D:
	get: return my_state_machine.nav_agent

func enter(msgs: Dictionary = {}) -> void:
	_nav_agent.set_target_position(_curr_action.target_unit.global_position)

func exit() -> void:
	_mover.set_input(Vector3.ZERO)
	_nav_agent.set_target_position(_unit.global_position)

# TODO: Increment/decrement speed based on the distance.
func physics_update(delta: float) -> void:
	var dist:     float = 10.0 # TODO: Have this dist based on the skill.
	var dist_sqr: float = dist * dist
	var d:        float = _unit.global_position.distance_squared_to(_curr_action.target_unit.global_position)
	if d <= dist_sqr:
		
		if _is_los_valid() == true:
			my_state_machine.change_to_state("AIExecuteAction")
			return
	
	elif _unit.curr_action_points < 1:
		pass
	
	var next_path_position: Vector3 = _nav_agent.get_next_path_position()
	var velocity = _unit.global_position.direction_to(next_path_position)
	_unit.update_amount_moved()
	_mover.set_input(velocity, false, false)
	_mover.orient_to_direction(-velocity, delta)
