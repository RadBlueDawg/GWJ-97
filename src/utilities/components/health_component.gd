class_name HealthComponent extends Node

signal health_changed(newHealth:float, maxHealth:float)
signal damage_taken(amount:float, source:Node3D)
signal died()

@export var MAX_HEALTH:float = 100.0
@export var START_AT_MAX:bool = true

var currentHealth:float
var isAlive:bool = true

func _ready() -> void:
	if START_AT_MAX:
		currentHealth = MAX_HEALTH

func take_damage(amount:float, source:Node3D = null) -> void:
	if not isAlive:
		return
	
	var actualDamage = max(0.0, amount)
	currentHealth = max(0.0, currentHealth - actualDamage)
	
	damage_taken.emit(actualDamage, source)
	health_changed.emit(currentHealth, MAX_HEALTH)
	
	print(get_parent().name, " took ", actualDamage, " damage. Health: ", currentHealth, "/", MAX_HEALTH)
	
	if currentHealth <= 0.0:
		_handle_death()

func heal(amount:float) -> void:
	if not isAlive:
		return
		
	var actualHeal = max(0.0, amount)
	currentHealth = min(MAX_HEALTH, currentHealth + actualHeal)
	
	health_changed.emit(currentHealth, MAX_HEALTH)

func _handle_death() -> void:
	if not isAlive:
		return
		
	isAlive = false
	currentHealth = 0.0
	died.emit()
	
	if owner:
		print(owner.name, " died!")
	else:
		print("Something from Trenchbroom died!")
