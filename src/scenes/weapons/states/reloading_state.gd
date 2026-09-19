extends WeaponState

func _on_reloading_state_entered() -> void:
	if not weaponController:
		return
		
	weaponController.reload_weapon()


func _on_reloading_state_physics_processing(_delta: float) -> void:
	if not weaponController:
		return
		
	if weaponController.currentAmmo == weaponController.CURRENT_WEAPON.MAX_AMMO:
		weaponController.WEAPON_STATE_CHART.send_event("onIdle")
