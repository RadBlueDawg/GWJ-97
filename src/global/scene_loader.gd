extends Node

signal progress_changed(progress)
signal load_finished

var loadingScreen: PackedScene = load(SceneRepo.FRAMEWORK.loading_screen)
var loadedResource: PackedScene
var scenePath: String
var progress: Array = []
var useSubThreads: bool = false

func _ready() -> void:
	set_process(false)
	
func load_scene(_scenePath:String) -> void:
	scenePath = _scenePath
	print("Now loading " + scenePath)
	
	var newLoadingScreen = loadingScreen.instantiate()
	add_child(newLoadingScreen)
	progress_changed.connect(newLoadingScreen._on_progress_changed)
	load_finished.connect(newLoadingScreen._on_load_finished)
	
	await newLoadingScreen.loading_screen_ready
	
	start_load()
	
func start_load() -> void:
	var state = ResourceLoader.load_threaded_request(scenePath, "", useSubThreads)
	if state == OK:
		set_process(true)
		
func _process(_delta: float) -> void:
	var loadStatus = ResourceLoader.load_threaded_get_status(scenePath, progress)
	progress_changed.emit(progress[0])
	match loadStatus:
		ResourceLoader.THREAD_LOAD_INVALID_RESOURCE, ResourceLoader.THREAD_LOAD_FAILED:
			print(loadStatus)
			set_process(false)
		ResourceLoader.THREAD_LOAD_LOADED:
			loadedResource = ResourceLoader.load_threaded_get(scenePath)
			get_tree().change_scene_to_packed(loadedResource)
			load_finished.emit()
			set_process(false)
