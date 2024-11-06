## A skill effect that spawns a projectile.
class_name SESpawnProjectile extends SkillEffect

## The projectile that this effect spawns.
@export var projectile_prefab: PackedScene

func execute(targeting_data: TargetingData) -> void:
	var projectile: Projectile = projectile_prefab.instantiate()
	
	# Although not every projectile will deal damage, save time by using damage for
	# healing and damage
	var stats: Stats = targeting_data.activator.combatant.stats
	var damage_data: DamageData        = DamageData.new()
	damage_data.damage_type            = damage_type
	damage_data.activator              = stats
	damage_data.damage_amount          = get_power(stats)
	damage_data.base_power_scale       = power_scale
	damage_data.damage_heal_percentage = attacker_heal_percentage
	
	projectile.initialize(
		targeting_data.target_v,
		targeting_data.activator.faction_owner,
		damage_data
	)
	
	targeting_data.activator.owner.add_child(projectile)
	projectile.global_position = targeting_data.origin + Vector3.UP
	await projectile.projectile_despawned
	effect_finished.emit()
