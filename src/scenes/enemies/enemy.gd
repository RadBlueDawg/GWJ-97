@abstract class_name Enemy extends CharacterBody3D

@export var ENEMY_GROUPS:Array[String] = []

@abstract func on_triggered() -> void

func _ready() -> void:
	for group in ENEMY_GROUPS:
		add_to_group(group)
