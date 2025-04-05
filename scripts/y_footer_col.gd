class_name YFooterCol extends Control

@export var footer_row_container: VBoxContainer
var y_footer_cell_scene = preload("res://scenes/y_footer_cell.tscn")
var cells = []
@export var scroll_container: ScrollContainer

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

func set_percent(percent: Vector2):
	var value_y = scroll_container.get_v_scroll_bar().max_value * percent.y
	scroll_container.scroll_vertical = roundi(value_y)
	var value_x = scroll_container.get_h_scroll_bar().max_value * percent.x
	scroll_container.scroll_horizontal = roundi(value_x)

func get_cell(index: int) -> YFooterCell:
	if (index >= 0 and index < cells.size()):
		return cells[index]
	return null

func set_error_lines(list: Array):
	for i in cells.size():
		if list.has(i):
			cells[i].set_error(true)
		else:
			cells[i].set_error(false)
