class_name EndgameScreen extends Control

func _ready() -> void:
	visible = false

func end_game(playerVictory:bool) -> void:
	get_tree().paused = true
	if playerVictory:
		$PanelContainer/GameOverText.text = "You survived the dungeon!"
	else:
		$PanelContainer/GameOverText.text = "You were lost to the dungeon!"
	
	visible = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_restart_button_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_quit_button_pressed() -> void:
	SceneLoader.load_scene(SceneRepo.FRAMEWORK.menu)
	get_tree().paused = false
