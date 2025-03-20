class_name XHeaderRow extends Control

@export var header_row_container: HBoxContainer
var x_header_cell_scene = preload("res://scenes/x_header_cell.tscn")
var cells = []

func generate_cells(values: Dictionary):
	if (cells.size() > 0):
		for i in cells:
			i.queue_free()
		cells.clear()
	for i in values:
		var new_cell = x_header_cell_scene.instantiate()
		new_cell.generate_labels(values[i])
		header_row_container.add_child(new_cell)
		cells.append(new_cell)
