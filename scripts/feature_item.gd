class_name FeatureItem extends PanelContainer

@export var label: Label
var description: String

func _on_mouse_entered() -> void:
	GlobalTooltip.show_tooltip(description)

func _on_mouse_exited() -> void:
	GlobalTooltip.hide_tooltip()

func set_text(stuff: String) -> void:
	label.text = stuff

func set_enabled(enabled: bool) -> void:
	if enabled:
		label.add_theme_color_override("font_color", Color(1, 1, 1))
	else:
		label.add_theme_color_override("font_color", Color(0.3, 0.3, 0.3))
