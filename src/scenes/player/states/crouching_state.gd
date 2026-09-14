extends PlayerState

func _on_crouching_state_physics_processing(delta: float) -> void:
	playerController.CAMERA.update_camera_height(delta, -1)
	
	if not Input.is_action_pressed("crouch") and playerController.is_on_floor() and not playerController.CROUCH_CHECK.is_colliding():
		playerController.STATE_CHART.send_event("onStanding")

func _on_crouching_state_entered() -> void:
	playerController.crouch()
