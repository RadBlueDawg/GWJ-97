@tool
class_name TriggerVolume extends Area3D

@export var TARGETS:Array[String] = []
@export var TRIGGER_ONCE:bool = false
@export var TRIGGER_ON_EXIT:bool = false
@export var DELAY:float = 0.0

var hasTriggered:bool = false

func _func_godot_apply_properties(entityProperties:Dictionary) -> void:
	var targetString = entityProperties.get("target", "") as String
	if targetString != "":
		var splitTargets = targetString.split(",", false)
		TARGETS.clear()
		for target in splitTargets:
			TARGETS.append(target.strip_edges())
	
	TRIGGER_ONCE = entityProperties.get("trigger_once", false) as bool
	TRIGGER_ON_EXIT = entityProperties.get("trigger_on_exit", false) as bool
	DELAY = entityProperties.get("delay", 0.0) as float

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	set_collision_mask_value(1, false)
	set_collision_mask_value(2, true)

func _on_body_entered(body:Node3D) -> void:
	if TRIGGER_ONCE and hasTriggered:
		return
	
	if body is PlayerController:
		hasTriggered = true
		
		if DELAY > 0.0:
			await get_tree().create_timer(DELAY).timeout
		
		_activate_targets(body)
	
func _on_body_exited(body:Node3D) -> void:
	if not TRIGGER_ON_EXIT:
		return
	
	if body is PlayerController:
		_deactivate_targets(body)
	
func _activate_targets(player:Node3D) -> void:
	if TARGETS.is_empty():
		return
	
	var entites = get_tree().get_nodes_in_group("map_entities")
	
	for targetName in TARGETS:
		for entity in entites:
			if entity.has_method("get_targetname") and entity.get_targetname() == targetName:
				if entity.has_method("on_trigger"):
					entity.on_trigger(player)	

func _deactivate_targets(player:Node3D) -> void:
	if TARGETS.is_empty():
		return
	
	var entites = get_tree().get_nodes_in_group("map_entities")
	
	for targetName in TARGETS:
		for entity in entites:
			if entity.has_method("get_targetname") and entity.get_targetname() == targetName:
				if entity.has_method("deactivate"):
					entity.deactivate(player)	
