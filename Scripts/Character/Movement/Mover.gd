## A component for handling movement for a character.
class_name Mover extends Node

@export_category("Movement Control Variables")
## How fast to move in this state. (Has nothing to do with stats.)
@export var move_speed: float = 10.0
## How fast it takes the character to get to their top speed.
@export var accel:      float = 60.0
## When not moving, this will help make the character stop moving.
@export var friction:   float = 50.0
var rot_speed: float = 10.0

@export_category("Jump & Gravity")
@export var max_jump_height:   float = 3   # How high we can jump
@export var min_jump_height:   float = 1   # How low we can jump
@export var time_to_jump_apex: float = 0.4 # How long, in seconds, it takes us to reach the height of our jump
var max_jump_velocity: float = 0
var min_jump_velocity: float = 0
var gravity:           float = 9.8

## Reference to the parent character body node. Needed to perform the movement.
var cb: CharacterBody3D

## The vector that is used to move a character after a direction is given.
var target_velocity: Vector3 = Vector3.ZERO

## The direction where a character wants to move to.
var input_dir: Vector3

func _ready() -> void:
	cb = get_parent()
	
	# Initialize the gravity
	gravity = (2 * max_jump_height) / (time_to_jump_apex * time_to_jump_apex)
	max_jump_velocity = sqrt(2 * gravity * max_jump_height)
	min_jump_velocity = sqrt(2 * gravity * min_jump_height)

func _physics_process(delta: float) -> void:
	move(delta)

func move(delta: float) -> void:
	_apply_acceleration(delta)
	_apply_friction(delta)
	handle_rotation(delta)
	
	target_velocity.y -= gravity * delta
	
	cb.set_velocity(target_velocity)
	cb.move_and_slide()

	if cb.is_on_floor() == true or cb.is_on_ceiling() == true:
		target_velocity.y = 0.0
		
func set_input(new_dir: Vector3, jump_pressed: bool = false, jump_released: bool = false) -> void:
	input_dir = new_dir
	if cb.is_on_floor() == true and jump_pressed == true:
		target_velocity.y = max_jump_velocity
	
	if cb.is_on_floor() == false and jump_released == true and target_velocity.y > min_jump_velocity:
		target_velocity.y = min_jump_velocity

## Used to make the character rotate towards the direction they're moving.
func handle_rotation(delta: float) -> void:
	if input_dir != Vector3.ZERO:
		cb.rotation.y = lerp_angle(
			cb.rotation.y,
			atan2(-input_dir.x, -input_dir.z),
			rot_speed * delta
		)

func _apply_acceleration(delta: float) -> void:
	if input_dir != Vector3.ZERO:
		target_velocity.x = target_velocity.move_toward(input_dir * move_speed, accel * delta).x
		target_velocity.z = target_velocity.move_toward(input_dir * move_speed, accel * delta).z

func _apply_friction(delta: float) -> void:
	if input_dir == Vector3.ZERO:
		target_velocity.x = target_velocity.move_toward(Vector3.ZERO, friction * delta).x
		target_velocity.z = target_velocity.move_toward(Vector3.ZERO, friction * delta).z
