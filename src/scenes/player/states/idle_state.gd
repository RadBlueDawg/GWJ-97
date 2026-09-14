extends PlayerState

func _on_idle_state_processing(_delta: float) -> void:
	if playerController and playerController.inputDirection.length() > 0:
		playerController.STATE_CHART.send_event("onMoving")
