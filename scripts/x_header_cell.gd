class_name XHeader extends Control

@export var numbers_container: VBoxContainer
@export var highlight_square: ColorRect
@export var error_square: ColorRect
var x_header_label_scene = preload("res://scenes/x_header_label.tscn")

func generate_labels(values: Array):
	for i in values:
		var new_label = x_header_label_scene.instantiate()
		new_label.set_text(i.length)
		numbers_container.add_child(new_label)

func set_highlighter(value: bool):
	highlight_square.visible = value

func set_error(value: bool):
	error_square.visible = value
