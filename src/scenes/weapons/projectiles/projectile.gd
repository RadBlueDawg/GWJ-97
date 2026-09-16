class_name Projectile extends Area3D

var velocity:Vector3
var damage:float

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	
	get_tree().create_timer(3.0).timeout.connect(queue_free)
	
func _physics_process(delta: float) -> void:
	var spaceState:PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
	var start = global_position
	var end = global_position + velocity * delta
	
	var query = PhysicsRayQueryParameters3D.create(start, end)
	query.collision_mask = 1
	var result:Dictionary = spaceState.intersect_ray(query)
	
	if result:
		global_position = result.position
		_on_body_entered(result.collider)
		return
	
	global_position = end
	
func setup(vel:Vector3, dmg:float) -> void:
	velocity = vel
	damage = dmg

func _on_body_entered(body:Node3D) -> void:
	print("Projectile hit: ", body.name, " at ", global_position)
	_spawn_impact_marker(global_position)
	_apply_damage_to_target(body)
	queue_free()

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

func _apply_damage_to_target(target:Node3D) -> void:
	var targetComponents = target.get_node_or_null("Components")
	if not targetComponents:
		return
	
	var healthComponent = targetComponents.get_node_or_null("HealthComponent")
	if healthComponent and healthComponent.has_method("take_damage"):
		healthComponent.take_damage(damage, self)
