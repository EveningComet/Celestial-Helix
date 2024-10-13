## Defines a state related to the player moving a character in battle.
class_name PLState extends State

var camera_controller: CameraController:
	get: return my_state_machine.camera_controller
