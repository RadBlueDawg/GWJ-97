class_name MouseCaptureComponent extends Node

@export var DEBUG:bool = false
@export_category("Mouse Capture Settings")
@export var CURRENT_MOUSE_MODE:Input.MouseMode = Input.MOUSE_MODE_CAPTURED
@export var MOUSE_SENSITIVITY:float = 0.05

var captureMouse:bool
var mouseInput:Vector2

func _unhandled_input(event: InputEvent) -> void:
	captureMouse = event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED
	if captureMouse:
		mouseInput.x += -event.screen_relative.x * MOUSE_SENSITIVITY
		mouseInput.y += -event.screen_relative.y * MOUSE_SENSITIVITY
	if DEBUG:
		print(mouseInput)
	
func _ready() -> void:
	Input.mouse_mode = CURRENT_MOUSE_MODE

func _process(_delta: float) -> void:
	mouseInput = Vector2.ZERO
