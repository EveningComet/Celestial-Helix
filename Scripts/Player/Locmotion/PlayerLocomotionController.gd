## Handles moving a player's unit.
class_name PlayerLocomotionController extends StateMachine

## Reference to the camera.
@export var camera_controller: CameraController

## Component that gets the player's input.
@export var input_controller: PlayerInputController

## The character currently being controlled by the player.
var active_participant: Unit

func _physics_process(delta: float) -> void:
	curr_state.physics_update( delta )
