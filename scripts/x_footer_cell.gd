class_name XFooterCell extends Panel

@export var label_container: VBoxContainer

func generate_labels(values: Array):
	for i in values:
		var new_label = Label.new()
		new_label.name = "Label_" + str(i)
		new_label.set_text(i)
		label_container.add_child(new_label)
		new_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
