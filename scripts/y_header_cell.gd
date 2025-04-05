class_name YHeader extends Control

@export var highlight_square: ColorRect
var y_header_label_scene = preload("res://scenes/y_header_label.tscn")
@export var error_square: ColorRect
@export var label: RichTextLabel

func generate_labels(line_data: Array):
	for i in range(line_data.size()):
		if (i > 0):
			label.text += "\t"
		label.text += str(line_data[i]["length"])

func set_highlighter(value: bool):
	highlight_square.visible = value

func set_error(value: bool):
	error_square.visible = value
