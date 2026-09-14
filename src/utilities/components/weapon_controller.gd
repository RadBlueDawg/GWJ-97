class_name WeaponController extends Node

@export var CURRENT_WEAPON: Weapon
@export var WEAPON_MODEL_PARENT:Node3D

var currentWeaponModel:Node3D

func _ready() -> void:
	if CURRENT_WEAPON:
		spawn_weapon_model()
		
func spawn_weapon_model() -> void:
	if currentWeaponModel:
		currentWeaponModel.queue_free()
	
	if CURRENT_WEAPON.MODEL:
		currentWeaponModel = CURRENT_WEAPON.MODEL.instantiate()
		WEAPON_MODEL_PARENT.add_child(currentWeaponModel)
		currentWeaponModel.position = CURRENT_WEAPON.POSITION
