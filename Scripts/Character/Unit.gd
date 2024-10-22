## A character that exists in the game world.
class_name Unit extends CharacterBody3D

## Activated when this character has 
signal finished_turn(unit: Unit)

## Fired when this character's action points have been changed.
signal ap_changed(unit: Unit)

@export_category("Action Points")
## The action points the unit currently has.
@export var curr_action_points: int = 3:
	get: return curr_action_points
	set(value):
		curr_action_points = value
		curr_action_points = clamp(curr_action_points, 0, max_action_points)
		ap_changed.emit(self)
		
		# When there are no more points left, end the turn
		if curr_action_points == 0:
			finished_turn.emit(self)

## When this character's turn starts, add this many action points.
@export var ap_on_new_turn: int = 3

## The max amount of action points a unit is allowed to have.
@export var max_action_points: int = 10

## Used to keep track of where a character was for changing action points.
var last_pos: Vector3 = Vector3.ZERO

## Keeps track of how much a unit has moved on their current turn.
var curr_move_amount: float = 0.0

## How many meters a character can move before it costs an action point.
@export var meters_per_ap: float = 10.0

@export_category("Components")
@export var skin_handler: SkinHandler

## Reference to the node that stores the character's stats, skills, and status
## effects.
@export var combatant:     Combatant
@export var mover:         Mover
@export var faction_owner: FactionOwner

## Perform a variety of cleanup and setup for this character when their turn starts.
func new_turn_setup() -> void:
	last_pos           = global_position
	curr_move_amount   = 0.0
	curr_action_points += ap_on_new_turn

func update_amount_moved() -> void:
	# TODO: Figure out accounting for jumping/flying.
	curr_move_amount += last_pos.distance_to(global_position)
	last_pos         = global_position
	if curr_move_amount >= meters_per_ap:
		curr_action_points -= 1
		curr_move_amount   = 0.0
