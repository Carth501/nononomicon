class_name BleedAway extends ColorRect

signal bleed_away_finished

var running: bool = false
var radius: float = 0.0
# var border_width: float = 0.0
@export var radius_speed: float = 1.5
# @export var width_speed: float = 1.5

func start_bleeding(coords: Vector2, new_color: Color):
	running = true
	material.resource_local_to_scene = true
	material.set_shader_parameter("position", coords)
	material.set_shader_parameter("color", new_color)
	radius = 0.0

func _process(delta: float) -> void:
	if running:
		radius += radius_speed * delta
		material.set_shader_parameter("radius", radius)
		# border_width += width_speed * delta
		if radius >= 1.5:
			running = false
			bleed_away_finished.emit()
			queue_free()
