class_name WeaponState extends Node

@export var DEBUG:bool = false

var weaponController:WeaponController

func _ready() -> void:
	if %WeaponStateMachine and %WeaponStateMachine is WeaponStateMachine:
		weaponController = %WeaponStateMachine.WEAPON_CONTROLLER
