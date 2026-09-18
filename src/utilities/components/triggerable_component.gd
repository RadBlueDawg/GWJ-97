@tool
class_name TriggerableComponent extends Node

@export var TARGET_NAME:String = ""

func _func_godot_apply_properties(entityProperties:Dictionary) -> void:
	TARGET_NAME = entityProperties.get("targetname", "") as String

func _ready() -> void:
	call_deferred("_add_to_group")
	
func _add_to_group() -> void:
	if owner:
		owner.add_to_group("map_entities")
