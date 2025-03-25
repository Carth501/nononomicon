class_name NonogramSquares extends GridContainer

var square_scene = preload("res://scenes/square.tscn")
var squares = []

func create_square_displays():
	if (squares.size() > 0):
		for i in squares:
			i.queue_free()
		squares.clear()
	var grid_size = State.get_size()
	columns = grid_size.x
	# The grid gets filled out horizontally first
	for k in grid_size.y:
		for i in grid_size.x:
			var new_square = square_scene.instantiate()
			new_square.setup(Vector2i(i, k))
			add_child(new_square)
			squares.append(new_square)
			new_square.set_square_appearance(State.get_position_state(Vector2i(i, k)))
