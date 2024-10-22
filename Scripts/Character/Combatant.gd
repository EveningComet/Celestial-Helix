## Component that represents a character that can take damage and die in the
## game world.
class_name Combatant extends Node

## Fired whenever the attached stat component has a change.
signal stat_changed(com: Combatant)

## Stores the stats for a character.
@export var stats: Stats = Stats.new(self)

## The component that stores a character's skills.
@export var skill_holder: SkillHolder = SkillHolder.new(self)
