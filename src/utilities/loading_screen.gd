extends CanvasLayer

signal loading_screen_ready

@export var ANIMATION_PLAYER:AnimationPlayer

func _ready() -> void:
	await ANIMATION_PLAYER.animation_finished
	loading_screen_ready.emit()

func _on_progress_changed(newValue:float) -> void:
	print(newValue)
	
func _on_load_finished() -> void:
	print("Loading complete")
	ANIMATION_PLAYER.play_backwards("transition")
	await ANIMATION_PLAYER.animation_finished
	queue_free()
