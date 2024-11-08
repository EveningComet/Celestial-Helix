class_name AIDecidingAction extends AIState

func enter(msgs: Dictionary = {}) -> void:
	var decision  = _get_best_decision(_potential_targets)
	var ai_action = decision.action as AIAction
	_curr_action  = ai_action
	
	my_state_machine.change_to_state("AIMovingTowardsTarget")

## Get the best thing this character should do at this moment in time.
func _get_best_decision(participants: Array[Unit] = []):
	var choices: Array[UtilityAIOption] = []
	
	for behavior: UtilityAIBehavior in my_state_machine.utility_behaviors:
		
		match behavior.name:
			"Attack Weakest":
				pass
		
		# Go through the skills, and find the best potential target
		for skill: SkillInstance in my_state_machine.skill_handler.get_activatable_skills():
			
			choices.append_array(
				_get_attack_choices(behavior, skill, participants)
			)
	
	# Get the decision
	var decision = UtilityAI.choose_highest(
		choices,
		my_state_machine.efficiency
	)
	
	if OS.is_debug_build() == true:
		print_rich("[color=green]AIDecidingAction :: The chosen context: %s[/color]" % [decision])
	
	return decision

func _get_attack_choices(
	behavior: UtilityAIBehavior,
	skill: SkillInstance,
	participants: Array[Unit]) -> Array[UtilityAIOption]:
	# Stores data that will be used by the AI to make its decisions
	var context: Dictionary = _initialize_context()
	var choices: Array[UtilityAIOption] = []
	
	for p_target: Unit in participants:
		if p_target == null:
			continue
		
		var potential_action: AIAction = AIAction.new()
		potential_action.skill = skill
		potential_action.target_unit = p_target
		var usable_skill_data: Dictionary = skill.skill.get_usable_data(_unit)
		
		# Find someone to target with the skill
		if _unit.faction_owner.is_same_faction(p_target.faction_owner) == false:
			context.target_hp = p_target.combatant.stats.get_curr_hp()
			context.distance_to_position = _unit.global_position.distance_to(p_target.global_position)
			
			# Create the choice with a value
			var choice = UtilityAIOption.new(
				behavior, context, potential_action
			)
			choices.append(choice)
	return choices

## Create a context object that will contain everything an AI will need to make
## a decision.
func _initialize_context() -> Dictionary:
	var context: Dictionary = {}
	context.target_hp        = 0
	context.potential_damage = 0
	context.my_hp   = _unit.combatant.stats.get_curr_hp()
	context.curr_ap = _unit.curr_action_points
	context.distance_to_position = 0.0
	return context
