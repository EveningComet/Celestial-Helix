## A component for handling movement for a character.
class_name Mover extends Node

## The component that will help with the animations.
@onready var skin_handler: SkinHandler = get_parent().get_node("SkinHandler")

@export_category("Movement Control Variables")
## How fast to move in this state. (Has nothing to do with stats.)
@export var move_speed: float = 10.0
## How fast it takes the character to get to their top speed.
@export var accel:      float = 60.0
## When not moving, this will help make the character stop moving.
@export var friction:   float = 50.0
@export var rot_speed: float = 10.0

@export_category("Jump & Gravity")
@export var max_jump_height:   float = 3   # How high we can jump
@export var min_jump_height:   float = 1   # How low we can jump
@export var time_to_jump_apex: float = 0.4 # How long, in seconds, it takes us to reach the height of our jump
var _max_jump_velocity: float = 0
var _min_jump_velocity: float = 0
var _gravity:           float = 9.8

## Reference to the parent character body node. Needed to perform the movement.
@onready var _cb: CharacterBody3D = get_parent()

## The vector that is used to move a character after a direction is given.
var _target_velocity: Vector3 = Vector3.ZERO

## The direction where a character wants to move to.
var _input_dir: Vector3

var _jumped: bool = false

func _ready() -> void:
	# Initialize the _gravity
	_gravity = (2 * max_jump_height) / (time_to_jump_apex * time_to_jump_apex)
	_max_jump_velocity = sqrt(2 * _gravity * max_jump_height)
	_min_jump_velocity = sqrt(2 * _gravity * min_jump_height)

func _physics_process(delta: float) -> void:
	_move(delta)
	_handle_animations(delta)

## Responsible for animating the character.
func _handle_animations(delta: float) -> void:
	
	if _cb.is_on_floor() == true:
		skin_handler.animation_tree["parameters/locomotion/playback"].travel("movement")
		var modified_dir = _target_velocity * _cb.transform.basis
		skin_handler.animation_tree.set(
			"parameters/locomotion/movement/blend_position",
			Vector2(modified_dir.x, -modified_dir.z) / move_speed
		)
	
	if _cb.is_on_floor() == false:
		skin_handler.animation_tree["parameters/locomotion/playback"].travel("falling")

func _move(delta: float) -> void:
	_apply_acceleration(delta)
	_apply_friction(delta)
	
	_target_velocity.y -= _gravity * delta
	
	_cb.set_velocity(_target_velocity)
	_cb.move_and_slide()

	if _cb.is_on_floor() == true or _cb.is_on_ceiling() == true:
		_target_velocity.y = 0.0
		
func set_input(new_dir: Vector3, was_jump_pressed: bool = false, was_jump_released: bool = false) -> void:
	_input_dir = new_dir
	if _cb.is_on_floor() == true and was_jump_pressed == true:
		_target_velocity.y = _max_jump_velocity
	
	if _cb.is_on_floor() == false and was_jump_released == true and _target_velocity.y > _min_jump_velocity:
		_target_velocity.y = _min_jump_velocity

## Used to make the character face the direction.
func orient_to_direction(desired_dir: Vector3, delta: float) -> void:
	var q_from         = _cb.transform.basis.get_rotation_quaternion()
	var left_axis      = Vector3.UP.cross(desired_dir)
	var rotation_basis = Basis(left_axis, Vector3.UP, desired_dir).get_rotation_quaternion()
	_cb.basis           = Basis(q_from.slerp(rotation_basis, rot_speed * delta))
	
	# Prevent weird stuff from happening
	_cb.transform.basis = _cb.transform.basis.orthonormalized()

## Applies the movement with smoothing.
func _apply_acceleration(delta: float) -> void:
	if _input_dir != Vector3.ZERO:
		_target_velocity.x = _target_velocity.move_toward(_input_dir * move_speed, accel * delta).x
		_target_velocity.z = _target_velocity.move_toward(_input_dir * move_speed, accel * delta).z

## Makes the stopping smooth.
func _apply_friction(delta: float) -> void:
	if _input_dir == Vector3.ZERO:
		_target_velocity.x = _target_velocity.move_toward(Vector3.ZERO, friction * delta).x
		_target_velocity.z = _target_velocity.move_toward(Vector3.ZERO, friction * delta).z
