class_name CameraController extends Node3D

@export var DEBUG:bool = false
@export_category("References")
@export var PLAYER_CONTROLLER:PlayerController
@export var COMPONENT_MOUSE_CAPTURE:MouseCaptureComponent
@export_category("Camera Settings")
@export_group("Camera Tilt")
@export_range(-90, -60) var TILT_LOWER_LIMIT:int = -90
@export_range(60, 90) var TILT_UPPER_LIMIT:int = 90
@export_group("Crouch Vertical Movement")
@export var CROUCH_OFFSET:float = 0.0
@export var CROUCH_SPEED:float = 3.0

const DEFAULT_HEIGHT:float = 0.5

var totalRotation:Vector3

func _process(_delta:float) -> void:
	update_camera_rotation(COMPONENT_MOUSE_CAPTURE.mouseInput)

func update_camera_rotation(input:Vector2) -> void:
	totalRotation.x += input.y
	totalRotation.y += input.x
	totalRotation.x = clamp(totalRotation.x, deg_to_rad(TILT_LOWER_LIMIT), deg_to_rad(TILT_UPPER_LIMIT))
	
	var playerRotation = Vector3(0.0, totalRotation.y, 0.0)
	var cameraRotation = Vector3(totalRotation.x, 0.0, 0.0)
	
	transform.basis = Basis.from_euler(cameraRotation)
	PLAYER_CONTROLLER.update_rotation(playerRotation)
	
	rotation.z = 0.0

func update_camera_height(delta:float, direction:int) -> void:
	if position.y >= CROUCH_OFFSET and position.y <= DEFAULT_HEIGHT:
		position.y = clampf(position.y + (CROUCH_SPEED * direction) * delta, CROUCH_OFFSET, DEFAULT_HEIGHT)
