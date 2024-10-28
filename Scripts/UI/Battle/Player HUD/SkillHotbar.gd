## Displays a character's activatable skills to the player.
class_name SkillHotbar extends PanelContainer

## How many buttons should be displayed at a minimum?
@export var minimum_skills_to_display: int = 8

## The node housing the buttons.
@export var button_container: Container

## Template for the skill button.
@export var skill_slot_prefab: PackedScene

## The character currently being controlled in the game.
var _curr_unit: Unit

func update_unit(new_unit: Unit) -> void:
	if _curr_unit != null:
		_curr_unit.ap_changed.disconnect( _on_ap_changed )
	
	_curr_unit = new_unit
	_curr_unit.ap_changed.connect( _on_ap_changed )
	_update_hotbar( _curr_unit.skill_handler )

## Updates the hotbar based on a character's current usable skills and whether
## or not the player can use those skills.
func _update_hotbar(skill_handler: SkillHandler) -> void:
	_clear_buttons()
	
	for i in minimum_skills_to_display:
		var skill_slot: SkillSlotUI = skill_slot_prefab.instantiate()
		skill_slot.disabled = true
		if i < skill_handler.get_activatable_skills().size():
			var skill_instance: SkillInstance = skill_handler.get_activatable_skills()[i]
			skill_slot.set_skill(skill_instance)
			
			# Check if the character can currently use the skill
			if _may_use_skill(skill_instance) == true:
				skill_slot.disabled = false
			
		button_container.add_child(skill_slot)

func _clear_buttons() -> void:
	for c in button_container.get_children():
		c.queue_free()

## Is the current unit able to use the skill?
func _may_use_skill(skill: SkillInstance) -> bool:
	# TODO: Account for the special point cost.
	# TODO: Remove duplicate code.
	return _curr_unit.curr_action_points >= skill.get_ap_cost() and skill.is_cooldown_finished() == true

## Method that reacts to a character's action points changing.
func _on_ap_changed(unit: Unit) -> void:
	_update_hotbar(unit.skill_handler)
