class_name NonogramSquares extends GridContainer

var square_scene = preload("res://scenes/square.tscn")
var squares = {}

func create_square_displays():
	for i in squares:
		squares[i].queue_free()
	squares.clear()
	var grid_size = State.get_size()
	columns = grid_size.x
	# The grid gets filled out horizontally first
	for k in grid_size.y:
		for i in grid_size.x:
			var new_square = square_scene.instantiate()
			var coords = Vector2i(i, k)
			new_square.setup(coords)
			add_child(new_square)
			squares[coords] = new_square
			new_square.set_square_appearance(State.get_position_state(Vector2i(i, k)))

func get_square(coords: Vector2i) -> NonogramSquare:
	if squares.has(coords):
		return squares[coords]
	else:
		return null