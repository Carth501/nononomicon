class_name XHeaderRow extends Control

@export var header_row_container: HBoxContainer
var x_header_cell_scene = preload("res://scenes/x_header_cell.tscn")

func generate_cells(values: Dictionary):
	for i in values.keys():
		var new_cell = x_header_cell_scene.instantiate()
		new_cell.generate_labels(Array(values[i]))
		header_row_container.add_child(new_cell)
