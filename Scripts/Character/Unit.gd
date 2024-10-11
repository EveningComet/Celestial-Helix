## A character that exists in the game world.
class_name Unit extends CharacterBody3D

## Activated when this character has 
signal finished_turn(unit: Unit)

@export var curr_action_points: int = 3

@export_category("Components")
## Reference to the node that stores the character's stats, skills, and status
## effects.
@export var combatant: Combatant
@export var faction_owner: FactionOwner
