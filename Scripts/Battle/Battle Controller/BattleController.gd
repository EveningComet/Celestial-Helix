## Responsible for managing the battles.
extends StateMachine

## Reference to the camera controller, which will be needed to swap to the
## different active characters.
@export var camera_controller: CameraController

## The current, active participants in a battle.
@export var participants: Array[Unit] = []

## Stores the characters that still need to act for the current turn.
var turn_queue: Array[Unit] = []

## The character that is currently having their turn performed.
var active_participant: Unit:
	get: return active_participant
	set(value): active_participant = value

func get_participants() -> Array[Unit]:
	return participants

func get_turn_queue() -> Array[Unit]:
	return turn_queue
