extends Control

@onready var inputButtonScene:PackedScene = preload("uid://bhaxj86w0rkfh")
@onready var actionList:VBoxContainer = $PanelContainer/MarginContainer/VBoxContainer/ScrollContainer/ActionList

var isRemapping:bool = false
var actionToRemap:String = ""
var remappingButton:Button = null

var inputActions:Dictionary = {
	"move_forward": "Move Forward",
	"move_backward": "Move Backward",
	"move_right": "Move Right",
	"move_left": "Move Left",
	"sprint": "Sprint",
	"crouch": "Crouch",
	"jump": "Jump",
	"weapon_fire": "Fire",
	"weapon_reload": "Reload",
	"pause": "Pause Game"
}

func _ready() -> void:
	_create_action_list()

func _create_action_list() -> void:
	UserOptions.load()
	
	for item in actionList.get_children():
		item.queue_free()
		
	for action in inputActions:
		var button:Button = inputButtonScene.instantiate()
		var actionLabel:Label = button.find_child("ActionLabel")
		var inputLabel:Label = button.find_child("InputLabel")
		
		actionLabel.text = inputActions[action]
		
		var events:Array[InputEvent] = InputMap.action_get_events(action)
		if events.size() > 0:
			inputLabel.text = events[0].as_text().trim_suffix(" - Physical")
		else:
			inputLabel.text = ""
		
		actionList.add_child(button)
		button.pressed.connect(_on_input_button_pressed.bind(button, action))


func _on_input_button_pressed(button:Button, action:String) -> void:
	if not isRemapping:
		isRemapping = true
		actionToRemap = action
		remappingButton = button
		button.find_child("InputLabel").text = "Press key to bind..."

func _input(event: InputEvent) -> void:
	if isRemapping:
		if event is InputEventKey or (event is InputEventMouseButton && event.is_pressed()):
			if event is InputEventMouseButton && event.is_double_click():
				event.set_double_click(false)
			
			InputMap.action_erase_events(actionToRemap)
			InputMap.action_add_event(actionToRemap, event)
			UserOptions.save()
			remappingButton.find_child("InputLabel").text = event.as_text().trim_suffix(" - Physical")
			
			isRemapping = false
			actionToRemap = ""
			remappingButton = null
			
			accept_event()

func _on_close_button_pressed() -> void:
	visible = false

func _on_reset_button_pressed() -> void:
	InputMap.load_from_project_settings()
	UserOptions.save()
	_create_action_list()
