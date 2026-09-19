class_name WeaponModel extends AnimatedSprite3D

func _ready() -> void:
	idle()

func idle() -> void:
	play("idle")

func fire() -> void:
	stop()
	play("fire")
	await animation_finished
	idle()

func reload() -> void:
	stop()
	play("reload")
	await animation_finished
	idle()
