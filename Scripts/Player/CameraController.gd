## Controls the battle camera.
class_name CameraController extends SpringArm3D

## How fast the camera moves.
@export var speed: float = 10.0

@export var offset: Vector3 = Vector3(0.0, 2, 0.0)

var target: Node3D = null

var mouse_sensitivity:      float = 0.1 # TODO: Clamp this between 0.1 and 1. Also, make this a global setting.
var controller_sensitivity: float = 3.0 # TODO: Make this a global setting.

# How far up and down the camera is allowed to tilt up and down
var min_pitch: float = -75.0
var max_pitch: float = 75.0
var wrap_0:   float = 0.0
var wrap_max: float = 360.0

func _ready() -> void:
	set_as_top_level(true)
	set_physics_process(false)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		# Rotate the x, and clamp the values
		rotation_degrees.x -= event.relative.y * mouse_sensitivity
		rotation_degrees.x = clamp(rotation_degrees.x, min_pitch, max_pitch)
			
		# Rotate for the y, and clamp the values so it doesn't go over values for reasons
		rotation_degrees.y -= event.relative.x * mouse_sensitivity
		rotation_degrees.y = wrapf(rotation_degrees.y, wrap_0, wrap_max)

func _physics_process(delta: float) -> void:
	handle_move(delta)
	apply_controller_rotation()

func apply_controller_rotation() -> void:
	var axis_vector = Vector2.ZERO
	axis_vector.y = Input.get_action_strength("look_right") - Input.get_action_strength("look_left")
	axis_vector.x = Input.get_action_strength("look_up") - Input.get_action_strength("look_down")
	if InputEventJoypadMotion:
		# Handle the controller's x rotation
		rotation_degrees.x -= axis_vector.x * controller_sensitivity
		rotation_degrees.x = clamp(rotation_degrees.x, min_pitch, max_pitch)
		
		# Handle the controller's y rotation
		rotation_degrees.y -= axis_vector.y * controller_sensitivity
		rotation_degrees.y = wrapf(rotation_degrees.y, wrap_0, wrap_max)

func handle_move(delta: float) -> void:
	global_position = lerp(global_position, target.global_position + offset, speed * delta)

## Update the target this camera should be following.
func set_target(new_target: Node3D) -> void:
	if target != null:
		remove_excluded_object(target)
	target = new_target
	add_excluded_object(target)
	set_physics_process(true)
