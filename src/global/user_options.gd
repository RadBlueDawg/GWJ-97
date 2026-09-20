extends Node

signal updated()

const configFileLocation:String = "user://options.cfg"
const configSection:String = "options"

func load() -> void:
	print("Loading user options")
	InputMap.load_from_project_settings()
	
	var configFile:ConfigFile = ConfigFile.new()
	var openResult:Error = configFile.load(configFileLocation)
	
	if openResult != OK:
		print("Config file doesn't exist, using default values")
		return
	
	var inputMap:Dictionary[String, InputEvent] = configFile.get_value(configSection, "input_map")
	for action in inputMap:
		InputMap.action_erase_events(action)
		InputMap.action_add_event(action, inputMap[action])

func save() -> void:
	print("Saving user options")
	var configFile:ConfigFile = ConfigFile.new()
	
	var inputMap:Dictionary[String, InputEvent] = {}
	for action in InputMap.get_actions():
		var events = InputMap.action_get_events(action)
		if events.size() > 0:
			inputMap[action] = events[0]
			
	configFile.set_value(configSection, "input_map", inputMap)
	
	configFile.save(configFileLocation)
	updated.emit()
