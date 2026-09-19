extends WeaponState

func _on_idle_state_processing(_delta:float) -> void:
	if not weaponController:
		return
	
	if Input.is_action_just_pressed("weapon_fire") and weaponController.can_fire():
		weaponController.WEAPON_STATE_CHART.send_event("onFiring")
		
	if Input.is_action_just_pressed("weapon_reload"):
		weaponController.WEAPON_STATE_CHART.send_event("onReloading")
		
	if weaponController.currentAmmo <= 0:
		weaponController.WEAPON_STATE_CHART.send_event("onEmpty")
