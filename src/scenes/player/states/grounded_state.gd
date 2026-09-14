extends PlayerState

func _on_grounded_state_physics_processing(_delta: float) -> void:
	if Input.is_action_just_pressed("jump") and playerController.is_on_floor():
		playerController.jump()
		playerController.STATE_CHART.send_event("onAirborne")
		
	if not playerController.is_on_floor():
		playerController.STATE_CHART.send_event("onAirborne")
