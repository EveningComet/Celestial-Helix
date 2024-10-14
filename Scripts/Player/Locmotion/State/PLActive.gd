## The plyer is actively controlling a unit.
class_name PLActive extends PLState

var active_participant: Unit

var input_dir: Vector3 = Vector3.ZERO

func enter(msgs: Dictionary = {}) -> void:
	match msgs:
		# The state entered with a player owned unit, so it's time to gain control
		{"new_unit": var new_unit}:
			active_participant = new_unit
	
	my_state_machine.active_participant.finished_turn.connect( _on_unit_turn_finished )

func exit() -> void:
	input_dir = Vector3.ZERO
	active_participant.mover.set_input(input_dir)
	active_participant = null
	my_state_machine.active_participant.finished_turn.disconnect( _on_unit_turn_finished )

func physics_update(delta: float) -> void:
	get_input()
	var jump_pressed:  bool = Input.is_action_just_pressed("jump")
	var jump_released: bool = Input.is_action_just_released("jump")
	active_participant.mover.set_input(input_dir, jump_pressed, jump_released)
	active_participant.mover.orient_to_face_camera_direction(camera_controller, delta)

func _on_unit_turn_finished(unit: Unit) -> void:
	my_state_machine.change_to_state("PLWaiting")

func get_input() -> void:
	input_dir = Vector3.ZERO
	input_dir.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_dir.z = Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward")
	
	# Change the input based on where the camera is looking
	var forward = camera_controller.basis.z
	var right   = camera_controller.basis.x
	input_dir   = forward * input_dir.z + right * input_dir.x
	
	# Normalize the vector and allow for smooth controller input
	input_dir = input_dir.normalized() if input_dir.length() > 1 else input_dir
