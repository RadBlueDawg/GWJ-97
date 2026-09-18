class_name GameManager extends Node

@export_category("References")
@export var PAUSE_MENU:PauseMenu

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		PAUSE_MENU.toggle_pause()
	if event.is_action_pressed("dev_exit"):
		get_tree().quit()
	if event.is_action_pressed("dev_reload"):
		get_tree().reload_current_scene()
