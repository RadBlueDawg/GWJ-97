class_name GameManager extends Node

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("dev_exit"):
		#SceneLoader.load_scene(SceneRepo.FRAMEWORK.menu)
		get_tree().quit()
	if event.is_action_pressed("dev_reload"):
		get_tree().reload_current_scene()
