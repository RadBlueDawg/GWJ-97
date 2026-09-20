class_name PauseMenu extends Control

signal game_paused
signal game_unpaused

func _ready() -> void:
	visible = false
	$InputSettings.visible = false

func toggle_pause() -> void:
	if get_tree().paused:
		unpause_game()
	else:
		pause_game()

func _on_resume_button_pressed() -> void:
	unpause_game()
	
func _on_options_button_pressed() -> void:
	$InputSettings.visible = true

func _on_quit_button_pressed() -> void:
	get_tree().paused = false
	SceneLoader.load_scene(SceneRepo.FRAMEWORK.menu)

func pause_game() -> void:
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	visible = true
	game_paused.emit()
	
func unpause_game() -> void:
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	visible = false
	game_unpaused.emit()
