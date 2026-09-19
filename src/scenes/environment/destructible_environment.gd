@tool
extends StaticBody3D

@export var MAX_HEALTH:float = 100.0

func _func_godot_apply_properties(entityProperties:Dictionary) -> void:
	MAX_HEALTH = entityProperties.get("max_health", 100.0) as float
	
func _ready() -> void:
	var componentsNode:Node  = Node.new()
	componentsNode.name = "Components"
	var healthComponentNode:HealthComponent = HealthComponent.new()
	healthComponentNode.name = "HealthComponent"
	healthComponentNode.MAX_HEALTH = MAX_HEALTH
	healthComponentNode.died.connect(_on_health_component_died)
	
	componentsNode.add_child(healthComponentNode)
	add_child(componentsNode)

func _on_health_component_died() -> void:
	queue_free()
