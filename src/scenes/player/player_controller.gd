class_name PlayerController extends CharacterBody3D

@export var DEBUG:bool = false
@export_category("References")
@export var CAMERA:CameraController
@export var STATE_CHART:StateChart
@export var STANDING_COLLISION:CollisionShape3D
@export var CROUCHING_COLLISION:CollisionShape3D
@export var CROUCH_CHECK:ShapeCast3D
@export_category("Movement Settings")
@export_group("Easing")
@export var ACCELERATION:float = 0.2
@export var DECELERATION:float = 0.5
@export_group("Speed")
@export var DEFAULT_SPEED:float = 7.0
@export var SPRINT_SPEED:float = 3.0
@export var CROUCH_SPEED:float = -5.0

var inputDirection:Vector2 = Vector2.ZERO
var movementVelocity:Vector3 = Vector3.ZERO
var sprintModifier:float = 0.0
var crouchModifier:float = 0.0
var speed:float = 0.0

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	var speedModifier = sprintModifier + crouchModifier
	speed = DEFAULT_SPEED + speedModifier
		
	inputDirection = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var currentVelocity = Vector2(movementVelocity.x, movementVelocity.z)
	var direction = (transform.basis * Vector3(inputDirection.x, 0, inputDirection.y)).normalized()
	
	if direction:
		currentVelocity = lerp(currentVelocity, Vector2(direction.x, direction.z) * speed, ACCELERATION)
	else:
		currentVelocity = currentVelocity.move_toward(Vector2.ZERO, DECELERATION)
		
	movementVelocity = Vector3(currentVelocity.x, velocity.y, currentVelocity.y)
	velocity = movementVelocity
	
	move_and_slide()

func update_rotation(rotationInput:Vector3) -> void:
	global_transform.basis = Basis.from_euler(rotationInput)

func walk() -> void:
	sprintModifier = 0.0

func sprint() -> void:
	sprintModifier = SPRINT_SPEED

func stand() -> void:
	crouchModifier = 0.0
	STANDING_COLLISION.disabled = false
	CROUCHING_COLLISION.disabled = true
	
func crouch() -> void:
	crouchModifier = CROUCH_SPEED
	STANDING_COLLISION.disabled = true
	CROUCHING_COLLISION.disabled = false
