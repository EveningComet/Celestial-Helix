## Responsible for displaying a skill visually to the player.
class_name SkillSlotUI extends Button # TODO: Could this not be a button?

@export var display_icon: TextureRect

## Used to display the action point cost to the player.
@export var action_cost_label: Label

## Setup the visuals for the skill to display.
func set_skill(skill: SkillInstance) -> void:
	if skill != null:
		display_icon.set_texture( skill.skill.display_icon )
		
		action_cost_label.set_text( str(skill.get_ap_cost()) )
