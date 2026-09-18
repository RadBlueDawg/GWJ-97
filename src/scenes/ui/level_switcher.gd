class_name LevelSwitcher extends Control

signal switch_level(levelUID:String)

@onready var LevelSelectOptions:OptionButton = $Panel/VBoxContainer/LevelSelectOptions

func _ready() -> void:
	visible = false

func toggle_open():
	LevelSelectOptions.selected = -1
	visible = not visible

func _on_switch_button_pressed() -> void:
	if LevelSelectOptions.selected < 0:
		return
	
	var selectedLevelKey = SceneRepo.LEVELS.keys()[LevelSelectOptions.selected]
	var selectedLevel:String = SceneRepo.LEVELS[selectedLevelKey]
	print("Switching to level ", selectedLevel)
	switch_level.emit(selectedLevel)
	visible = false
	LevelSelectOptions.selected = -1
