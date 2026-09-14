class_name PlayerState extends Node

@export var DEBUG:bool = false

var playerController:PlayerController

func _ready() -> void:
	if %StateMachine and %StateMachine is PlayerStateMachine:
		playerController = %StateMachine.PLAYER_CONTROLLER
