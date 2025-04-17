class_name Guidelines extends Control

var lines = []

func create_lines(interval: Vector2i):
	if lines.size() > 0:
		for line in lines:
			line.queue_free()
		lines.clear()
	create_verticals(interval.x)
	create_horizontals(interval.y)

func create_verticals(interval: int):
	if interval == 0:
		return
	if interval < 0:
		push_error("Interval cannot be negative")
	var grid_size = State.get_size()
	var x_number = floori(grid_size.x / float(interval))
	if (grid_size.x % interval) == 0:
		x_number -= 1
	for i in range(x_number):
		var line = ColorRect.new()
		line.size.x = 6
		line.size.y = grid_size.y * 64
		line.position = Vector2(((i + 1) * interval * 64) - 3, 0)
		line.color = Color("adadad")
		add_child(line)
		lines.append(line)

func create_horizontals(interval: int):
	if interval == 0:
		return
	if interval < 0:
		push_error("Interval cannot be negative")
	var grid_size = State.get_size()
	var y_number = floori(grid_size.y / float(interval))
	if (grid_size.y % interval) == 0:
		y_number -= 1
	for i in range(y_number):
		var line = ColorRect.new()
		line.size.x = grid_size.x * 64
		line.size.y = 6
		line.position = Vector2(0, ((i + 1) * interval * 64) - 3)
		line.color = Color("adadad")
		add_child(line)
		lines.append(line)
