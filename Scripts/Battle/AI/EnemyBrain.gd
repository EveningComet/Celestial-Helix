## Defines how an enemy works.
class_name EnemyBrain extends Node

## Defines what a particular enemy can do. These are the actions it can take.
@export var behaviors: Array[UtilityAIBehavior] = []

## How "brutal" this character is when making a decision. The higher the value, the
## "smarter" the enemy will appear.
@export_range(0.0, 1.0, .05) var efficiency: float = 0.80

## Need to keep track of the stats.
@onready var _skill_handler: SkillHandler      = get_parent().get_node("SkillHandler")
@onready var _nav_agent:     NavigationAgent3D = get_parent().get_node("NavigationAgent3D")
@onready var _unit:          Unit              = get_parent()

func do_turn() -> void:
	# First, get the best thing to do
	var decision = _get_best_decision()
	
	# A decision was found, now find a place to move to
	
	# Done, finish the turn
	await get_tree().create_timer(1.0, false, true).timeout
	_unit.finished_turn.emit( _unit )

## Get the best thing this character should do at this moment in time.
func _get_best_decision():
	
	var choices: Array[UtilityAIOption] = []
	
	# Stores data that will be used by the AI to make its decisions
	var context: Dictionary = _initialize_context()
	
	for behavior: UtilityAIBehavior in behaviors:
		
		# Go through the skills, and find the best potential target
		for skill: SkillInstance in _skill_handler.get_activatable_skills():
			var potential_action: AIAction = AIAction.new()
			var usable_skill_data: Dictionary = skill.skill.get_usable_data(_unit)
			
			# Find someone to target with the skill
			
			# Create the choice with a value
			var choice = UtilityAIOption.new(
				behavior, context, potential_action
			)
			
			choices.append(choice)
	
	# Get the decision
	var decision = UtilityAI.choose_highest(
		choices,
		efficiency
	)
	
	if OS.is_debug_build() == true:
		print_rich("[color=green]EnemyBrain :: The chosen context:\n%s[/color]" % [decision])
	
	return decision

func _initialize_context() -> Dictionary:
	var context: Dictionary = {}
	context.target_hp        = 0
	context.potential_damage = 0
	context.my_hp   = _unit.combatant.stats.get_curr_hp()
	context.curr_ap = _unit.curr_action_points
	context.distance_to_position = 0.0
	return context
