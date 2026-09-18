class_name PlayerHUD extends Control

func set_starting_health(maxHealth:float) -> void:
	$HealthBar.max_value = maxHealth
	$HealthBar.value = maxHealth

func set_current_health(currentHealth:float) -> void:
	$HealthBar.value = currentHealth
