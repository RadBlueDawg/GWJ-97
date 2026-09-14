extends RayCast3D

var currentObject:Object

func _process(_delta: float) -> void:
	
	if is_colliding():
		var object = get_collider()
		if object == currentObject:
			return
		else:
			currentObject = object
	else:
		currentObject = null
