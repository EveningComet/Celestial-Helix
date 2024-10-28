## Stores a collection of objects that will need to be used by the player during a battle.
class_name PlayerBattleController extends Node

@export var input_controller:      PlayerInputController
@export var locomotion_controller: PlayerLocomotionController

## The player owned character currently being controlled.
var _active_participant: Unit = null

func _ready() -> void:
	Eventbus.new_active_participant.connect( _on_participant_changed )
	input_controller.use_skill_index.connect( _on_use_skill_index )

## What to do when the player is trying to use a skill.
func _on_use_skill_index(index: int) -> void:
	if _active_participant != null:
		var skill_handler = _active_participant.skill_handler
		var desired_skill = skill_handler.get_skill_at_index(index)
		if desired_skill != null and _may_use_skill(desired_skill) == true:
			skill_handler.execute_skill(desired_skill)
		if OS.is_debug_build() == true:
			print("PlayerBattleController :: Attempting to use skill index: %s" % [str(index)])

## Keep track of the player's active unit.
func _on_participant_changed(new_participant: Unit) -> void:
	_active_participant = null
	if new_participant.faction_owner.is_player_owned() == true:
		_active_participant = new_participant

## Is the current unit able to use the skill?
func _may_use_skill(skill: SkillInstance) -> bool:
	# TODO: Account for the special point cost.
	# TODO: There is duplicate code in SkillHotbar.gd.
	return _active_participant.curr_action_points >= skill.get_ap_cost() and skill.is_cooldown_finished() == true
