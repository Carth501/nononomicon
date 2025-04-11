class_name YHeader extends Control

@export var highlight_square: ColorRect
var y_header_label_scene = preload("res://scenes/y_header_label.tscn")
@export var error_square: ColorRect
@export var label: RichTextLabel
var labels: Array = []

func generate_labels(line_data: Array):
	for i in range(line_data.size()):
		if (i > 0):
			label.text += "\t"
		label.text += str(line_data[i]["length"])

func set_highlighter(value: bool):
	highlight_square.visible = value

func set_error(value: bool):
	error_square.visible = value

func set_assist(comparison: Array):
	for i in labels.size():
		if comparison[i]:
			label.set("theme_override_colors/font_color", Color(0.1, 0.9, 0.1))
		else:
			label.set("theme_override_colors/font_color", Color(1, 1, 1))
