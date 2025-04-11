class_name XHeaderRow extends HBoxContainer

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
		add_child(new_cell)
		cells.append(new_cell)

func get_cell(index: int) -> XHeader:
	if (index >= 0 and index < cells.size()):
		return cells[index]
	return null
	
func set_error_lines(list: Array):
	for i in cells.size():
		if list.has(i):
			cells[i].set_error(true)
		else:
			cells[i].set_error(false)

func set_assist(comparisons: Dictionary):
	for i in cells.size():
		if comparisons.has(i):
			cells[i].set_assist(comparisons[i])
