@tool
extends Control

@export var RADIUS:float = 30.0 : set = set_crosshair_radius
@export var THICKNESS:float = 1.0 : set = set_crosshair_thickness
@export var COLOR:Color = Color.WHITE : set = set_crosshair_color
@export var GAP_ANGLE:float = 45.0 : set = set_crosshair_gap_angle
@export var SEGMENTS:int = 32 : set = set_crosshair_segments

func _draw() -> void:
	var gapAngleRad = deg_to_rad(GAP_ANGLE)
	
	var arcSegments = [
		#Bottom-right
		[gapAngleRad / 2, PI / 2 - gapAngleRad / 2],
		#Bottom-left
		[PI / 2 + gapAngleRad / 2, PI - gapAngleRad / 2],
		#Top-left
		[PI + gapAngleRad / 2, 3 * PI / 2 - gapAngleRad / 2],
		#Top-right
		[3 * PI / 2 + gapAngleRad / 2, 2 * PI - gapAngleRad / 2]
	]
	
	for arc in arcSegments:
		var startAngle = arc[0]
		var endAngle = arc[1]
		
		var points = []
		var angleStep = (endAngle - startAngle) / SEGMENTS
		
		for i in range(SEGMENTS + 1):
			var angle = startAngle + i * angleStep
			var point = Vector2(RADIUS * cos(angle), RADIUS * sin(angle))
			points.append(point)
		
		if points.size() > 1:
			draw_polyline(points, COLOR, THICKNESS, true)

func update_crosshair() -> void:
	queue_redraw()

func set_crosshair_radius(newRadius:float) -> void:
	RADIUS = newRadius
	update_crosshair()


func set_crosshair_color(newColor:Color) -> void:
	COLOR = newColor
	update_crosshair()


func set_crosshair_thickness(newThickness:float) -> void:
	THICKNESS = newThickness
	update_crosshair()


func set_crosshair_gap_angle(newGapAngle:float) -> void:
	GAP_ANGLE = newGapAngle
	update_crosshair()


func set_crosshair_segments(newSegments:int) -> void:
	SEGMENTS = newSegments
	update_crosshair()
