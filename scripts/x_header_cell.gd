extends VBoxContainer

var x_header_label_scene = preload("res://scenes/x_header_label.tscn")

func generate_labels(values: Array):
	for i in values:
		var new_label = x_header_label_scene.instantiate()
		new_label.set_text(i.length)
		add_child(new_label)
