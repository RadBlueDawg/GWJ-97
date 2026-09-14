extends PlayerState

func _on_walking_state_processing(_delta: float) -> void:
	if Input.is_action_pressed("sprint"):
		playerController.STATE_CHART.send_event("onSprinting")

func _on_walking_state_entered() -> void:
	playerController.walk()
