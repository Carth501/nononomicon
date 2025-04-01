class_name YFooterCol extends Control

@export var footer_row_container: HBoxContainer
var y_footer_cell_scene = preload("res://scenes/y_footer_cell.tscn")
var cells = []
@export var y_scroll_container: ScrollContainer

func generate_cells(values: Dictionary, length: int):
	if (cells.size() > 0):
		for i in cells:
			i.queue_free()
		cells.clear()
	for i in range(length):
		var new_cell = y_footer_cell_scene.instantiate()
		if (values.has(i)):
			new_cell.set_name("Cell_" + str(i))
			new_cell.generate_labels(values[i])
		else:
			new_cell.set_name("Empty_Cell_" + str(i))
		footer_row_container.add_child(new_cell)
		cells.append(new_cell)

func set_percent_y(percent: float):
	var value = y_scroll_container.get_v_scroll_bar().max_value * percent
	y_scroll_container.scroll_vertical = roundi(value)
