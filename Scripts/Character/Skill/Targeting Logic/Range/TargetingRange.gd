## Base class for a component that defines where a [SkillData] object should get
## targets.
class_name TargetingRange extends Resource

func get_targeting_data(activator: Unit, target_v: Vector3) -> TargetingData:
	var targeting_data: TargetingData = TargetingData.new()
	targeting_data.activator = activator
	targeting_data.target_v  = target_v
	targeting_data.targets   = []
	targeting_data.origin    = activator.global_position
	return targeting_data
