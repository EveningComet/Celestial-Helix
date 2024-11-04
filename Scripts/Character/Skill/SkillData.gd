## A collection of data for a skill.
class_name SkillData extends Resource

## Fired when a skill has finished going through all its effects.
signal skill_executed

@export_category("Base Info")
@export var localization_name:                  String = "New Skill"
@export_multiline var localization_description: String = "New description."
@export var display_icon: Texture2D

@export_category("Definitions")
@export var base_sp_cost:    int  = 5
@export var base_ap_cost:    int  = 1
@export var base_cooldown:   int  = 0 ## In turns, how long must a character wait before activating this again?
@export var is_passive:      bool = false
@export var num_activations: int  = 1

## The objects that define how this skill should do things.
@export var effects: Array[SkillEffect] = []

func execute(targeting_data: TargetingData) -> void:
	# Loop through the effects and wait for them to finish
	for e: SkillEffect in effects:
		e.execute(targeting_data)
		await e.effect_finished
	
	# Everything is done. Return control
	skill_executed.emit()
