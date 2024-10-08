## A collection of data for a skill.
class_name SkillData extends Resource

@export_category("Base Info")
@export var localization_name:                  String = "New Skill"
@export_multiline var localization_description: String = "New description."

@export_category("Definitions")
@export var base_cost:       int  = 5
@export var is_passive:      bool = false
@export var num_activations: int  = 1

## The objects that define how this skill should do things.
@export var effects: Array[SkillEffect] = []
