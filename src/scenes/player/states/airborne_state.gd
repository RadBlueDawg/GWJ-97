extends PlayerState


func _on_airborne_state_physics_processing(_delta: float) -> void:
	if playerController.is_on_floor():
		playerController.STATE_CHART.send_event("onGrounded")
