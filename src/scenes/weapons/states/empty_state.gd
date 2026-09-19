extends WeaponState

func _on_empty_state_entered() -> void:
	print("Weapon empty!")

func _on_empty_state_processing(_delta:float) -> void:
	if Input.is_action_just_pressed("weapon_reload"):
		weaponController.WEAPON_STATE_CHART.send_event("onReloading")
