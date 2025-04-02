class_name XFooterCell extends Control

@export var label_container: VBoxContainer
@export var highlight_square: ColorRect

func generate_labels(values: Array):
	for i in values:
		var new_label = Label.new()
		new_label.name = "Label_" + str(i)
		new_label.set_text(i)
		label_container.add_child(new_label)
		new_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

func set_highlighter(value: bool):
	highlight_square.visible = value
