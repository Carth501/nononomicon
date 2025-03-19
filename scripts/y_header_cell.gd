extends HBoxContainer

var y_header_label_scene = preload("res://scenes/y_header_label.tscn")
var segments: Dictionary = {}

func generate_labels(values: Dictionary):
	print(values)
	for i in values:
		var new_label = y_header_label_scene.instantiate()
		new_label.set_text(i)
		add_child(new_label)
