extends PlayerState

func _on_moving_state_physics_processing(_delta: float) -> void:
	if playerController.inputDirection.length() == 0 and playerController.velocity.length() < 0.5:
		playerController.STATE_CHART.send_event("onIdle")
