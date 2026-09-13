class_name PlayerController extends CharacterBody3D

@export var DEBUG:bool = false
@export_category("References")
@export var CAMERA:CameraController

func update_rotation(rotationInput:Vector3) -> void:
	global_transform.basis = Basis.from_euler(rotationInput)
