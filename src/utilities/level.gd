class_name Level extends Node3D

@export var DEBUG:bool = false
@export_category("References")
@export var LEVEL_TRANSITION:LevelTransition
@export_category("Settings")
@export var PLAYER_START_POSITION:Vector3

signal change_level(sceneUID:String)

func _ready() -> void:
	if LEVEL_TRANSITION:
		LEVEL_TRANSITION.body_entered.connect(_on_level_transition_entered)
		
func _on_level_transition_entered(body: Node3D) -> void:
	if body is PlayerController:
		change_level.emit(LEVEL_TRANSITION.DESTINATION_LEVEL)
