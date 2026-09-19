class_name Weapon extends Resource

@export var NAME:String = "Pistol"
@export var DAMAGE:float = 25.0
@export var FIRE_WINDUP:float = 0.0
@export var FIRE_RATE:float = 0.0
@export var MAX_AMMO:int = 12
@export var RELOAD_DELAY:float = 2.0
@export var RANGE:float = 25
@export_range(0, 100) var ACCURACY:int = 100
@export var PROJECTILE_SPEED:float = 50.0
@export var IS_HITSCAN:bool = true
@export var MODEL: PackedScene
@export var PROJECTILE: PackedScene
@export var PELLET_COUNT:int = 1
@export var SPREAD_ANGLE:float = 0.0
@export var POSITION:Vector3 = Vector3(0.2, -0.2, -0.3)
