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
