class_name YHeaderCol extends Control

@export var header_row_container: HBoxContainer
var y_header_cell_scene = preload("res://scenes/y_header_cell.tscn")

func generate_cells(values: Dictionary):
	for i in values.keys():
		var new_cell = y_header_cell_scene.instantiate()
		new_cell.generate_labels(values[i])
		add_child(new_cell)
