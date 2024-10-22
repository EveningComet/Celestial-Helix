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
	_update_hotbar( _curr_unit.combatant.skill_holder )

## Updates the hotbar based on a character's current usable skills and whether
## or not the player can use those skills.
func _update_hotbar(skill_holder: SkillHolder) -> void:
	_clear_buttons()
	
	for i in minimum_skills_to_display:
		var skill_slot: SkillSlotUI = skill_slot_prefab.instantiate()
		if i < skill_holder.get_activatable_skills().size():
			skill_slot.set_skill(skill_holder.get_activatable_skills()[i])
		button_container.add_child(skill_slot)

func _clear_buttons() -> void:
	for c in button_container.get_children():
		c.queue_free()

## Method that reacts to a character's action points changing.
func _on_ap_changed(unit: Unit) -> void:
	pass
