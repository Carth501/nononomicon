class_name YFooterCol extends VBoxContainer

var y_footer_cell_scene = preload("res://scenes/y_footer_cell.tscn")
var cells = []

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
			new_cell.set_complication(true)
		else:
			new_cell.set_name("Empty_Cell_" + str(i))
			new_cell.set_complication(false)
		add_child(new_cell)
		cells.append(new_cell)

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
