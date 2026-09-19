class_name WeaponController extends Node

@export_category("References")
@export var CAMERA:Camera3D
@export var CURRENT_WEAPON: Weapon
@export var WEAPON_MODEL_PARENT:Node3D
@export var WEAPON_STATE_CHART:StateChart

signal ammo_changed(current:int, max:int)

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
		if currentWeaponModel is WeaponModel:
			currentWeaponModel.fire()
		
		await get_tree().create_timer(CURRENT_WEAPON.FIRE_WINDUP).timeout
		currentAmmo -= 1
		print("Fired! Ammo: ", currentAmmo)
		ammo_changed.emit(currentAmmo, CURRENT_WEAPON.MAX_AMMO)
		
		if CURRENT_WEAPON.IS_HITSCAN:
			_perform_hitscan()
		else:
			_spawn_projectile()
		
func reload_weapon() -> void:
	if currentWeaponModel is WeaponModel:
		currentWeaponModel.reload()
	
	await get_tree().create_timer(CURRENT_WEAPON.RELOAD_DELAY).timeout
	currentAmmo = CURRENT_WEAPON.MAX_AMMO
	print("Reloaded! Ammo: ", currentAmmo)
	ammo_changed.emit(currentAmmo, CURRENT_WEAPON.MAX_AMMO)

func _perform_hitscan() -> void:
	if not CAMERA:
		print("No camera assigned!")
		return
	
	var spaceState:PhysicsDirectSpaceState3D = CAMERA.get_world_3d().direct_space_state
	var from:Vector3 = CAMERA.global_position
	var forward:Vector3 = -CAMERA.global_transform.basis.z
	var to:Vector3 = from + forward * CURRENT_WEAPON.RANGE
	
	var query = PhysicsRayQueryParameters3D.create(from, to)
	var result:Dictionary = spaceState.intersect_ray(query)
	
	if result:
		print("Hit: ", result.collider.name, " at ", result.position)
		_spawn_impact_marker(result.position)
		_apply_damage_to_target(result.collider)
		
func _spawn_impact_marker(position:Vector3) -> void:
	var marker = MeshInstance3D.new()
	var box = BoxMesh.new()
	box.size = Vector3(0.1, 0.1, 0.1)
	marker.mesh = box
	
	var material = StandardMaterial3D.new()
	material.albedo_color = Color.RED
	marker.set_surface_override_material(0, material)
	
	get_tree().current_scene.add_child(marker)
	marker.global_position = position
	
	get_tree().create_timer(2.0).timeout.connect(marker.queue_free)

func _spawn_projectile() -> void:
	if not CURRENT_WEAPON.PROJECTILE:
		print("No projectile scene assigned!")
		return
	
	if not CAMERA:
		print("No camera assigned!")
		return
		
	var projectile = CURRENT_WEAPON.PROJECTILE.instantiate() as Projectile
	get_tree().current_scene.add_child(projectile)
	
	projectile.global_position = CAMERA.global_position
	
	var forward = -CAMERA.global_transform.basis.z
	var velocity = forward * CURRENT_WEAPON.PROJECTILE_SPEED
	projectile.look_at(projectile.global_position + forward, Vector3.UP)
	projectile.setup(velocity, CURRENT_WEAPON.DAMAGE)

func _apply_damage_to_target(target:Node3D) -> void:
	var targetComponents = target.get_node_or_null("Components")
	if not targetComponents:
		return
	
	var healthComponent = targetComponents.get_node_or_null("HealthComponent")
	if healthComponent and healthComponent.has_method("take_damage"):
		healthComponent.take_damage(CURRENT_WEAPON.DAMAGE, owner)
