class_name GameManager extends Node

@export_category("References")
@export var PAUSE_MENU:PauseMenu
@export var LEVEL_SWITCHER:LevelSwitcher
@export var CURRENT_LEVEL_HOLDER:Node3D
@export var PLAYER_CONTROLLER:PlayerController
@export var PLAYER_HUD:PlayerHUD
@export var ENDGAME_SCREEN:EndgameScreen

var gameOver:bool = false
var loadingScreen: PackedScene = load(SceneRepo.FRAMEWORK.loading_screen)

func _ready() -> void:
	gameOver = false
	var currentLevel = CURRENT_LEVEL_HOLDER.get_children()[0] as Level
	PLAYER_CONTROLLER.global_position = currentLevel.PLAYER_START_POSITION
	PLAYER_CONTROLLER.HEALTH_COMPONENT.damage_taken.connect(_on_player_damage_taken)
	PLAYER_CONTROLLER.HEALTH_COMPONENT.died.connect(_on_player_died)
	PLAYER_CONTROLLER.WEAPON_CONTROLLER.ammo_changed.connect(_on_player_ammo_changed)
	PLAYER_HUD.set_starting_health(PLAYER_CONTROLLER.HEALTH_COMPONENT.MAX_HEALTH)
	
func _unhandled_input(event: InputEvent) -> void:
	if not gameOver:
		if event.is_action_pressed("pause"):
			PAUSE_MENU.toggle_pause()
		if event.is_action_pressed("dev_reload"):
			get_tree().reload_current_scene()
		if event.is_action_pressed("dev_switch"):
			LEVEL_SWITCHER.toggle_open()
	
	if event.is_action_pressed("dev_exit"):
			get_tree().quit()

func _on_change_level(sceneUID:String) -> void:
	if not CURRENT_LEVEL_HOLDER:
		return
		
	var newLoadingScreen = loadingScreen.instantiate()
	add_child(newLoadingScreen)
	await newLoadingScreen.loading_screen_ready
	
	var newScene:PackedScene = load(sceneUID)
	
	for child in CURRENT_LEVEL_HOLDER.get_children():
		if child is Level:
			child.change_level.disconnect(_on_change_level)
			
		child.queue_free()
		CURRENT_LEVEL_HOLDER.remove_child(child)
	
	var newLevel = newScene.instantiate() as Level
	newLevel.change_level.connect(_on_change_level)
		
	CURRENT_LEVEL_HOLDER.add_child(newLevel)
	PLAYER_CONTROLLER.global_position = newLevel.PLAYER_START_POSITION
	
	newLoadingScreen._on_load_finished()

func _on_player_damage_taken(_amount:float, _source:Node3D) -> void:
	PLAYER_HUD.set_current_health(PLAYER_CONTROLLER.HEALTH_COMPONENT.currentHealth)
	
func _on_player_died() -> void:
	gameOver = true
	ENDGAME_SCREEN.end_game(false)
	
func _on_player_ammo_changed(currentAmmo:int, maxAmmo:int) -> void:
	pass
