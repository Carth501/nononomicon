class_name YHeader extends Control

@export var numbers_container: HBoxContainer
@export var highlight_square: ColorRect
var y_header_label_scene = preload("res://scenes/y_header_label.tscn")

func generate_labels(values: Array):
	for i in values:
		var new_label = y_header_label_scene.instantiate()
		new_label.set_text(i.length)
		numbers_container.add_child(new_label)

func set_highlighter(value: bool):
	highlight_square.visible = value
