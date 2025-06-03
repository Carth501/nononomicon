class_name NonogramSquares extends GridContainer

var square_scene = preload("res://scenes/square.tscn")
var squares = {}

func create_square_displays():
	for i in squares.keys():
		for j in squares[i].keys():
			squares[i][j].queue_free()
		squares[i].clear()
	squares.clear()
	var grid_size = State.get_size()
	columns = grid_size.x
	# The grid gets filled out horizontally first
	for k in grid_size.y:
		for i in grid_size.x:
			if not squares.has(i):
				squares[i] = {}
			var new_square = square_scene.instantiate()
			new_square.setup(Vector2i(i, k))
			add_child(new_square)
			squares[i][k] = new_square
			new_square.set_square_appearance(State.get_position_state(Vector2i(i, k)))

func get_square(coords: Vector2i) -> NonogramSquare:
	if squares.has(coords.x):
		if squares[coords.x].has(coords.y):
			return squares[coords.x][coords.y]
	return null

func clear_hint_squares():
	for i in squares.keys():
		for j in squares[i].keys():
			squares[i][j].set_hint_square(false)

func get_squares() -> Array:
	var square_list = []
	for i in squares.keys():
		for j in squares[i].keys():
			square_list.append(squares[i][j])
	return square_list
