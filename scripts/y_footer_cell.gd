class_name YFooterCell extends Panel

@export var label_container: HBoxContainer

func generate_labels(values: Array):
	for i in values:
		var new_label = Label.new()
		new_label.rotation_degrees = -90
		new_label.name = "Label_" + str(i)
		new_label.set_text(i)
		label_container.add_child(new_label)
		new_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
