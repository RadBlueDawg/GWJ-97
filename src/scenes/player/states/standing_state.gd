extends PlayerState

func _on_standing_state_physics_processing(delta: float) -> void:
	playerController.CAMERA.update_camera_height(delta, 1)
	
	if Input.is_action_pressed("crouch") and playerController.is_on_floor():
		playerController.STATE_CHART.send_event("onCrouching")

func _on_standing_state_entered() -> void:
	playerController.stand()
