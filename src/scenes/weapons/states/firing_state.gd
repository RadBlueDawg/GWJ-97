extends WeaponState

func _on_firing_state_entered() -> void:
	if not weaponController:
		return
		
	get_tree().create_timer(weaponController.CURRENT_WEAPON.FIRE_WINDUP).timeout.connect(_on_fire_windup_elapsed)
	
func _on_firing_state_physics_processing(_delta:float) -> void:
	if not weaponController:
		return
	
	if weaponController.currentAmmo <= 0:
		weaponController.WEAPON_STATE_CHART.send_event("onEmpty")

func _on_fire_windup_elapsed() -> void:
	weaponController.fire_weapon()
	get_tree().create_timer(weaponController.CURRENT_WEAPON.FIRE_DELAY).timeout.connect(_on_fire_delay_elapsed)

func _on_fire_delay_elapsed() -> void:
	weaponController.WEAPON_STATE_CHART.send_event("onIdle")
