class_name XFooterRow extends Control

@export var footer_row_container: HBoxContainer
var x_footer_cell_scene = preload("res://scenes/x_footer_cell.tscn")
var cells = []
@export var x_scroll_container: ScrollContainer

func generate_cells(values: Dictionary):
	if (cells.size() > 0):
		for i in cells:
			i.queue_free()
		cells.clear()
	for i in values:
		var new_cell = x_footer_cell_scene.instantiate()
		new_cell.generate_labels(values[i])
		footer_row_container.add_child(new_cell)
		cells.append(new_cell)

func set_percent_x(percent: float):
	var value = x_scroll_container.get_h_scroll_bar().max_value * percent
	x_scroll_container.scroll_horizontal = roundi(value)