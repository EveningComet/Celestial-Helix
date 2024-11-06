## Defines a skill that should directly apply healing.
class_name HealEffect extends SkillEffect

func execute(targeting_data: TargetingData) -> void:
	for t: Unit in targeting_data.targets:
		if t != null:
			t.combatant.stats.heal( get_power(targeting_data.activator.combatant.stats) )
	effect_finished.emit()
