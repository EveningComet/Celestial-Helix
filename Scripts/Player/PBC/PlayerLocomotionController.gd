## Handles moving a player's unit.
class_name PlayerLocomotionController extends Node
# TODO: Make this class handle the movement instead of PBActive directly.

## Reference to the camera.
@export var camera_controller: CameraController

## Component that gets the player's input.
@export var input_controller: PlayerInputController

## The character currently being controlled by the player.
var _curr_unit: Unit = null

## Is the player currently allowed to move the active unit?
var _movement_disabled: bool    = false
var _input_dir:         Vector3 = Vector3.ZERO

func _ready() -> void:
	set_physics_process(false)

## Set the new unit.
func set_unit(new_unit: Unit) -> void:
	_curr_unit = new_unit
	_curr_unit.finished_turn.connect( _on_unit_turn_finished )
	set_physics_process(true)

func _physics_process(delta: float) -> void:
	if _movement_disabled != true:
		_get_input()
		_curr_unit.mover.set_input(
			_input_dir, input_controller.jump_pressed, input_controller.jump_released
		)
		_curr_unit.update_amount_moved()
	
	_curr_unit.mover.orient_to_face_camera_direction(
		camera_controller, delta
	)
	

## Get the new input dir.
func _get_input() -> void:
	_input_dir = input_controller.input_dir
	
	# Change the input based on where the camera is looking
	var forward = camera_controller.basis.z
	var right   = camera_controller.basis.x
	_input_dir   = forward * _input_dir.z + right * _input_dir.x
	
	# Normalize the vector and allow for smooth controller input
	_input_dir = _input_dir.normalized() if _input_dir.length() > 1 else _input_dir

## End of unit turn clean up.
func _on_unit_turn_finished(unit: Unit) -> void:
	_input_dir = Vector3.ZERO
	_curr_unit.mover.set_input(Vector3.ZERO)
	_curr_unit.finished_turn.disconnect( _on_unit_turn_finished )
	_curr_unit = null
	set_physics_process(false)
