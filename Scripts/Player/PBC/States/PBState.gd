## Defines a state that a player can be in during a battle.
class_name PBState extends State

var camera_controller: CameraController:
	get: return my_state_machine.camera_controller

var input_controller: PlayerInputController:
	get: return my_state_machine.input_controller

var _curr_unit: Unit = null

## Is the current unit able to use the skill?
func _may_use_skill(skill: SkillInstance) -> bool:
	# TODO: Account for the special point cost.
	# TODO: There is duplicate code in SkillHotbar.gd.
	return _curr_unit.curr_action_points >= skill.get_ap_cost() and skill.is_cooldown_finished() == true

## End of turn unit clean up.
func _on_unit_turn_finished(unit: Unit) -> void:
	my_state_machine.change_to_state("States/PBWaiting")
