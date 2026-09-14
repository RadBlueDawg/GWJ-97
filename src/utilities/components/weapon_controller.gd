class_name WeaponController extends Node

@export var CURRENT_WEAPON: Weapon
@export var WEAPON_MODEL_PARENT:Node3D
@export var WEAPON_STATE_CHART:StateChart

var currentWeaponModel:Node3D
var currentAmmo:int

func _ready() -> void:
	if CURRENT_WEAPON:
		spawn_weapon_model()
		currentAmmo = CURRENT_WEAPON.MAX_AMMO
		
func spawn_weapon_model() -> void:
	if currentWeaponModel:
		currentWeaponModel.queue_free()
	
	if CURRENT_WEAPON.MODEL:
		currentWeaponModel = CURRENT_WEAPON.MODEL.instantiate()
		WEAPON_MODEL_PARENT.add_child(currentWeaponModel)
		currentWeaponModel.position = CURRENT_WEAPON.POSITION

func can_fire() -> bool:
	return currentAmmo > 0

func fire_weapon() -> void:
	if can_fire():
		currentAmmo -= 1
		print("Fired! Ammo: ", currentAmmo)
