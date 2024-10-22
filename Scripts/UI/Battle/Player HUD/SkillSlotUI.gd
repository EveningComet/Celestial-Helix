## Responsible for displaying a skill visually to the player.
class_name SkillSlotUI extends Button # TODO: Could this just be not a button?

@export var display_icon: TextureRect

func set_skill(skill: SkillInstance) -> void:
	if skill != null:
		display_icon.set_texture( skill.skill.display_icon )
