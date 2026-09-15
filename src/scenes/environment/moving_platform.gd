@tool
class_name MovingPlatform extends AnimatableBody3D

@export var MOVE_DISTANCE:float = 2.0
@export var MOVE_TIME:float = 2.0
@export var MOVE_DIRECTION:Vector3 = Vector3(0, 1, 0)

var startPosition:Vector3
var endPosition:Vector3
var platformTween:Tween

func _func_godot_apply_properties(entityProperties:Dictionary) -> void:
	MOVE_DISTANCE = entityProperties["move_distance"] as float
	MOVE_TIME = entityProperties["move_time"] as float
	MOVE_DIRECTION = entityProperties["move_direction"] as Vector3
	
func _ready() -> void:
	if not Engine.is_editor_hint():
		startPosition = global_position
		endPosition = startPosition + (MOVE_DIRECTION.normalized() * MOVE_DISTANCE)
		_start_movement()
		
func _start_movement() -> void:
	platformTween = create_tween()
	platformTween.set_loops()
	platformTween.tween_property(self, "global_position", endPosition, MOVE_TIME)
	platformTween.tween_property(self, "global_position", startPosition, MOVE_TIME)
