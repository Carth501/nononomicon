class_name XHeader extends Control

@export var numbers_container: VBoxContainer
@export var highlight_square: ColorRect
@export var error_square: ColorRect
var x_header_label_scene = preload("res://scenes/x_header_label.tscn")
var labels: Array = []

func generate_labels(values: Array):
	for i in values:
		var new_label = x_header_label_scene.instantiate()
		new_label.set_text(i.length)
		numbers_container.add_child(new_label)
		labels.append(new_label)

func set_highlighter(value: bool):
	highlight_square.visible = value

func set_error(value: bool):
	error_square.visible = value

func set_assist(comparison: Array):
	for i in labels.size():
		if comparison[i]:
			labels[i].set("theme_override_colors/font_color", Color(0.1, 0.9, 0.1))
		else:
			labels[i].set("theme_override_colors/font_color", Color(1, 1, 1))
