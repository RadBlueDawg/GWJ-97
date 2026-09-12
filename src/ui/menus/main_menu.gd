extends Control


func _on_play_button_pressed() -> void:
	SceneLoader.load_scene(SceneRepo.FRAMEWORK.test_level)


func _on_options_button_pressed() -> void:
	pass # Replace with function body.


func _on_credits_button_pressed() -> void:
	pass # Replace with function body.


func _on_quit_button_pressed() -> void:
	get_tree().quit()
