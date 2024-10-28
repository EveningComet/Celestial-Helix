## Stores a collection of objects that will need to be used by the player during a battle.
class_name PlayerBattleController extends StateMachine

@export var camera_controller:      CameraController
@onready var input_controller:      PlayerInputController      = $PlayerInputController
@onready var locomotion_controller: PlayerLocomotionController = $PlayerLocomotionController

func set_me_up() -> void:
	# Initialize the states on the data side
	for child in get_node("States").get_children():
		states[child.name] = child
		states[child.name].setup_state( self )
	curr_state = get_node(initial_state)
	curr_state.enter()

func _physics_process(delta: float) -> void:
	curr_state.physics_update( delta )
