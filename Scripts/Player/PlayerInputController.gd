## Handles getting controls for the player.
class_name PlayerInputController extends Node

## When the player hits a skill button, this event will tell anything that's interested
## about the event being fired.
signal use_skill_index(index: int)

## Used to cancel targeting/readying for a skill.
signal cancel_skill_usage

var input_dir: Vector3 = Vector3.ZERO

var jump_pressed:  bool = false
var jump_released: bool = false

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		cancel_skill_usage.emit()
		return
	
	if event.is_action_pressed("use_skill_1"):
		use_skill_index.emit(0)
		if OS.is_debug_build() == true:
			print("PlayerInputController :: Pressed use skill 1.")
	
	elif event.is_action_pressed("use_skill_2"):
		use_skill_index.emit(1)
		if OS.is_debug_build() == true:
			print("PlayerInputController :: Pressed use skill 2.")
	
	elif event.is_action_pressed("use_skill_3"):
		use_skill_index.emit(2)
		if OS.is_debug_build() == true:
			print("PlayerInputController :: Pressed use skill 3.")

func _process(delta: float) -> void:
	input_dir   = Vector3.ZERO
	input_dir.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_dir.z = Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward")
	
	jump_pressed  = Input.is_action_just_pressed("jump")
	jump_released = Input.is_action_just_released("jump")
