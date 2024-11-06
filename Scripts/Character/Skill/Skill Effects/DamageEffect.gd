## Defines a skill that should directly apply damage.
class_name DamageEffect extends SkillEffect

func execute(targeting_data: TargetingData) -> void:
	# Setup the damage data
	var stats: Stats = targeting_data.activator.combatant.stats
	var damage_data: DamageData        = DamageData.new()
	damage_data.damage_type            = damage_type
	damage_data.activator              = stats
	damage_data.damage_amount          = get_power(stats)
	damage_data.base_power_scale       = power_scale
	damage_data.damage_heal_percentage = attacker_heal_percentage
	
	for t: Unit in targeting_data.targets:
		if t != null:
			t.combatant.stats.take_damage(damage_data)
	effect_finished.emit()
