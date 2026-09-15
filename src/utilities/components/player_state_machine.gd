class_name PlayerStateMachine extends Node

@export var DEBUG:bool = false
@export_category("References")
@export var PLAYER_CONTROLLER:PlayerController

func _process(_delta: float) -> void:
	if PLAYER_CONTROLLER:
		PLAYER_CONTROLLER.STATE_CHART.set_expression_property("Player Velocity", PLAYER_CONTROLLER.velocity)
		PLAYER_CONTROLLER.STATE_CHART.set_expression_property("Player Hitting Head", PLAYER_CONTROLLER.CROUCH_CHECK.is_colliding())
		PLAYER_CONTROLLER.STATE_CHART.set_expression_property("Looking At: ", PLAYER_CONTROLLER.INTERACTION_RAYCAST.currentObject)
