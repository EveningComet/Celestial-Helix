## Stores what an AI will do.
class_name AIAction extends Resource

## The skill the AI is going to do.
var skill: SkillInstance = null

## The [Unit] this AI will be targeting with their skill, if their is one.
var target_unit: Unit = null

## The position this AI should move to.
var target_position: Vector3 = Vector3.ZERO
