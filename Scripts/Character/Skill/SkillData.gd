## A collection of data for a skill.
class_name SkillData extends Resource

## Fired when a skill has finished going through all its effects.
signal skill_executed

@export_category("Base Info")
@export var localization_name:                  String = "New Skill"
@export_multiline var localization_description: String = "New description."
@export var display_icon: Texture2D

@export_category("Targeting")
## Defines "where" a skill targets.
@export var targeting_range: TargetingRange

## This is what gets targeted where.
@export var targeting_aoe:   TargetingAOE

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

## Go through the stored effects and return an object storing something that can
## be used to make decisions.
func get_usable_data(activator: Unit) -> Dictionary:
	var a_stats: Stats = activator.combatant.stats
	var data: Dictionary = {}
	data.damage_datas  = []
	data.ap_cost          = base_ap_cost
	data.healing_power = 0
	for e: SkillEffect in effects:
		
		if e is DamageEffect:
			var dd: DamageData  = DamageData.new()
			dd.damage_amount    = e.get_power(a_stats)
			dd.damage_type      = e.damage_type
			dd.base_power_scale = e.power_scale
			dd.status_damage_scaler = e.bonus_damage_scale_on_debuffs_present
			dd.damage_heal_percentage = e.attacker_heal_percentage
			data.damage_datas.append( dd )
		
		elif e is HealEffect:
			data.healing_power += (e as HealEffect).get_power(a_stats)
		
		elif e is SESpawnProjectile:
			pass
	
	return data
