## Defines how an enemy works.
class_name EnemyBrain extends StateMachine

## Helps the AI with determining if it has a clear sight on a target.
@export var los_ray: RayCast3D

## Defines what a particular enemy can do. These are the actions it can take.
@export var utility_behaviors: Array[UtilityAIBehavior] = []

## How "brutal" this character is when making a decision. The higher the value, the
## "smarter" the enemy will appear.
@export_range(0.0, 1.0, .05) var efficiency: float = 0.80

## Need to keep track of the stats.
@onready var unit:          Unit              = get_parent()
@onready var skill_handler: SkillHandler      = get_parent().get_node("SkillHandler")
@onready var nav_agent:     NavigationAgent3D = get_parent().get_node("NavigationAgent3D")
@onready var mover:         Mover             = get_parent().get_node("Mover")

var potential_targets: Array[Unit] = []
var curr_action: AIAction = null

func do_turn(participants: Array[Unit]) -> void:
	potential_targets = participants
	change_to_state("AIDecidingAction")

func _physics_process(delta: float) -> void:
	curr_state.physics_update(delta)
