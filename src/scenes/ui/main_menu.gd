extends Control

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	$CreditsContainer.visible = false
	$InputSettings.visible = false
	$MarginContainer/HBoxContainer/VersionNumberLabel.text = GlobalData.version

func _on_play_button_pressed() -> void:
	SceneLoader.load_scene(SceneRepo.FRAMEWORK.main_playspace)

func _on_options_button_pressed() -> void:
	$InputSettings.visible = true

func _on_credits_button_pressed() -> void:
	$CreditsContainer.visible = true

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_close_credits_button_pressed() -> void:
	$CreditsContainer.visible = false

func _on_credits_text_meta_clicked(meta: Variant) -> void:
	OS.shell_open(str(meta))
