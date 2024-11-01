## A skill effect that spawns a projectile.
class_name SESpawnProjectile extends SkillEffect

## The projectile that this effect spawns.
@export var projectile_prefab: PackedScene

func execute(targeting_data: TargetingData) -> void:
	print("SESpawnProjectile :: Fired.")
	var projectile: Projectile = projectile_prefab.instantiate()
	projectile.initialize(
		targeting_data.direction,
		targeting_data.activator.faction_owner
	)
	targeting_data.activator.owner.add_child(projectile)
	projectile.global_position = targeting_data.origin
