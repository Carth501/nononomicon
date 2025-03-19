class_name NonogramSquares extends GridContainer

var square_scene = preload("res://scenes/square.tscn")

func create_square_displays():
	var map = State.master[State.SQUARE_MAP_KEY]
	columns = map.keys().size()
	for i in map.keys().size():
		for k in map[0].size():
			var new_square = square_scene.instantiate()
			new_square.setup(Vector2i(i, k))
			add_child(new_square)
