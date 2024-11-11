class_name AIState extends State

var _unit: Unit:
	get: return my_state_machine.unit

var _mover: Mover:
	get: return my_state_machine.mover

var _potential_targets: Array[Unit]:
	get: return my_state_machine.potential_targets
	
var _curr_action: AIAction:
	get: return my_state_machine.curr_action
	set(value):
		my_state_machine.curr_action = value
	
var _los_ray: RayCast3D:
	get: return my_state_machine.los_ray

## Is the line of sight valid?
func _is_los_valid() -> bool:
	# Handle the line of sight check
	_los_ray.look_at_from_position(
		_los_ray.global_position,
		_curr_action.target_unit.global_position + Vector3.UP
	)
	_los_ray.force_raycast_update()
	if _los_ray.is_colliding() == true:
		var collider = _los_ray.get_collider()
		if collider == _curr_action.target_unit:
			return true
	
	return false
