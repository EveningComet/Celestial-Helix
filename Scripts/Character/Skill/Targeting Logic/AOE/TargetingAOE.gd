## [SkillData] objects need to know where to get a target, and what around that area
## needs to be gotten.
class_name TargetingAOE extends Resource

## The area collider, if this component needs it.
@export var collider: PackedScene

func get_targets(activator: Unit, target_v: Vector3) -> Array[Unit]:
	return []
