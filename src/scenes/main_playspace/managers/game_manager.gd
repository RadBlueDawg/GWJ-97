class_name GameManager extends Node

@export_category("References")
@export var PAUSE_MENU:PauseMenu
@export var LEVEL_SWITCHER:LevelSwitcher
@export var CURRENT_LEVEL_HOLDER:Node3D

var loadingScreen: PackedScene = load(SceneRepo.FRAMEWORK.loading_screen)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		PAUSE_MENU.toggle_pause()
	if event.is_action_pressed("dev_exit"):
		get_tree().quit()
	if event.is_action_pressed("dev_reload"):
		get_tree().reload_current_scene()
	if event.is_action_pressed("dev_switch"):
		LEVEL_SWITCHER.toggle_open()

func _on_level_switcher_switch_level(levelUID: String) -> void:
	if not CURRENT_LEVEL_HOLDER:
		return
		
	var newLoadingScreen = loadingScreen.instantiate()
	add_child(newLoadingScreen)
	await newLoadingScreen.loading_screen_ready
	
	var newLevel:PackedScene = load(levelUID)
	
	for child in CURRENT_LEVEL_HOLDER.get_children():
		child.queue_free()
		CURRENT_LEVEL_HOLDER.remove_child(child)
	
	CURRENT_LEVEL_HOLDER.add_child(newLevel.instantiate())
	newLoadingScreen._on_load_finished()
