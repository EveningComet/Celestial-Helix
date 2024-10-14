## A character that exists in the game world.
class_name Unit extends CharacterBody3D

## Activated when this character has 
signal finished_turn(unit: Unit)

## The action points the unit currently has.
@export var curr_action_points: int = 3

## When this character's turn starts, add this many action points.
@export var ap_on_new_turn: int = 3

@export_category("Components")
## Reference to the node that stores the character's stats, skills, and status
## effects.
@export var combatant:     Combatant
@export var mover:         Mover
@export var faction_owner: FactionOwner

func new_turn_setup() -> void:
	curr_action_points += ap_on_new_turn
