extends WeaponState

func _on_firing_state_entered() -> void:
	if not weaponController:
		return
		
	weaponController.fire_weapon()
	
func _on_firing_state_physics_processing(_delta:float) -> void:
	if not weaponController:
		return
	
	if weaponController.currentAmmo <= 0:
		weaponController.WEAPON_STATE_CHART.send_event("onEmpty")
		return
	
	weaponController.WEAPON_STATE_CHART.send_event("onIdle")
