class_name SimpleEnemy extends Enemy

@export_category("References")
@export var NAV_AGENT:NavigationAgent3D
@export var STATE_CHART:StateChart
@export var HEALTH_COMPONENT:HealthComponent
@export var ANIMATED_SPRITE:AnimatedSprite3D
@export_category("Settings")
@export var FOLLOW_SPEED:float = 3.0
@export var MELEE_RANGE:float = 1.6
@export var MELEE_DAMAGE:float = 25.0

var target:Node3D

func _ready() -> void:
	super._ready()
	
	target = get_tree().get_first_node_in_group("player")
	
	if ANIMATED_SPRITE:
		ANIMATED_SPRITE.play("default")

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	move_and_slide()

func on_triggered() -> void:
	STATE_CHART.send_event("onFollow")
	
func get_targetname() -> String:
	return ""
	
func on_trigger(_player) -> void:
	STATE_CHART.send_event("onFollow")

func _on_follow_state_physics_processing(delta: float) -> void:
	if not target:
		return
		
	NAV_AGENT.target_position = target.global_position
	
	if in_attack_range():
		STATE_CHART.send_event("onAttack")
		return
	
	if NAV_AGENT.is_navigation_finished():
		NAV_AGENT.velocity = Vector3.ZERO
		if ANIMATED_SPRITE:
			ANIMATED_SPRITE.stop()
			ANIMATED_SPRITE.play("default")
		return
	
	var nextPos = NAV_AGENT.get_next_path_position()
	var direction = (nextPos - global_position).normalized()
	
	NAV_AGENT.velocity = direction * FOLLOW_SPEED
	
	if direction.length() > 0.01:
		var targetRotation = atan2(direction.x, direction.z)
		rotation.y = lerp_angle(rotation.y, targetRotation, 5.0 * delta)


func _on_detection_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("player") and HEALTH_COMPONENT.isAlive:
		on_triggered()

func _on_health_component_died() -> void:
	STATE_CHART.send_event("onDeath")

func _on_navigation_agent_3d_velocity_computed(safeVelocity: Vector3) -> void:
	velocity.x = safeVelocity.x
	velocity.z = safeVelocity.z

func attack() -> void:
	velocity = Vector3.ZERO
	NAV_AGENT.velocity = Vector3.ZERO
	
	ANIMATED_SPRITE.stop()
	ANIMATED_SPRITE.play("attack")
	await ANIMATED_SPRITE.animation_finished
	print("Slice!")
	_apply_damage_to_target()
	
	if target and HEALTH_COMPONENT.isAlive:
		if in_attack_range():
			STATE_CHART.send_event("onAttack")
		else:
			STATE_CHART.send_event("onFollow")

func _on_attack_state_entered() -> void:
	attack()
	
func in_attack_range() -> bool:
	var distance = global_position.distance_to(target.global_position)
	return distance <= MELEE_RANGE

func _on_follow_state_entered() -> void:
	if ANIMATED_SPRITE:
		ANIMATED_SPRITE.play("move")

func _on_death_state_entered() -> void:
	velocity = Vector3.ZERO
	NAV_AGENT.velocity = Vector3.ZERO
	collision_layer = 0
	ANIMATED_SPRITE.stop()
	ANIMATED_SPRITE.play("death")
	await ANIMATED_SPRITE.animation_finished
	get_tree().create_timer(1.0).timeout.connect(queue_free)

func _apply_damage_to_target() -> void:
	var targetComponents = target.get_node_or_null("Components")
	if not targetComponents:
		return
	
	var healthComponent = targetComponents.get_node_or_null("HealthComponent")
	if healthComponent and healthComponent.has_method("take_damage"):
		healthComponent.take_damage(MELEE_DAMAGE, self)

func _on_health_component_damage_taken(_amount: float, _source: Node3D) -> void:
	on_triggered()
