extends Node

signal square_changed(coords)
signal board_ready

enum SquareStates {
	EMPTY,
	MARKED,
	NOTE_MARKED,
	FLAGGED,
	NOTE_FLAGGED
}

var chosen_coords: Vector2i = Vector2i(-1, -1)
var master: Dictionary
var SIZE := Vector2i(9, 9)
var SQUARE_MAP_KEY := 'square_map'
var TARGET_MAP_KEY := 'target_map'
var HEADERS_KEY := 'headers'

func _ready() -> void:
	generate_empty_map()
	generate_target_map()

func set_chosen_coords(new_coords: Vector2i):
	chosen_coords = new_coords

func get_position_state(coords: Vector2i) -> SquareStates:
	return master [SQUARE_MAP_KEY][coords.x][coords.y]

func change_square_state(new_state: SquareStates):
	if (chosen_coords == Vector2i(-1, -1)):
		return
	if (master [SQUARE_MAP_KEY][chosen_coords.x][chosen_coords.y] == new_state):
		master [SQUARE_MAP_KEY][chosen_coords.x][chosen_coords.y] = SquareStates.EMPTY
	else:
		master [SQUARE_MAP_KEY][chosen_coords.x][chosen_coords.y] = new_state
	square_changed.emit(chosen_coords)

func generate_empty_map():
	if (SIZE.x <= 0 || SIZE.y <= 0):
		printerr("Invalid map size: ", SIZE)
	master [SQUARE_MAP_KEY] = {}
	for i in SIZE.x:
		var column: Array[SquareStates] = []
		for k in SIZE.y:
			column.append(SquareStates.EMPTY)
		master [SQUARE_MAP_KEY][i] = column
	board_ready.emit()

func _process(_delta):
	if Input.is_action_just_pressed("Mark"):
		change_square_state(SquareStates.MARKED)
	elif Input.is_action_just_pressed("Flag"):
		change_square_state(SquareStates.FLAGGED)

func generate_target_map():
	random_center_map()
	generate_headers()

func random_center_map():
	master [TARGET_MAP_KEY] = {}
	for i in SIZE.x:
		master [TARGET_MAP_KEY][i] = {}
		for k in SIZE.y:
			var average = roundi((SIZE.x + SIZE.y) / 2.0)
			var random_value = randi_range(-2, 2)
			var sum = absi(i - roundi(average / 2.0)) + absi(k - roundi(average / 2.0))
			sum += random_value
			var marked = sum < roundi(average / 1.95)
			if (marked):
				master [TARGET_MAP_KEY][i][k] = SquareStates.MARKED
			else:
				master [TARGET_MAP_KEY][i][k] = SquareStates.EMPTY

func generate_headers():
	master [HEADERS_KEY] = {}
	master [HEADERS_KEY]['X'] = {}
	master [HEADERS_KEY]['Y'] = {}
	var map = master [TARGET_MAP_KEY]

	generate_header_for_axis('Y', SIZE.x, SIZE.y, map)
	generate_header_for_axis('X', SIZE.y, SIZE.x, map)

func generate_header_for_axis(axis: String, primary_size: int, secondary_size: int, map: Dictionary):
	for i in primary_size:
		var total = 0
		var count = 0
		var segment = []
		master [HEADERS_KEY][axis][i] = []
		for k in secondary_size:
			var is_marked = false
			if axis == 'X':
				is_marked = map[i].has(k) and map[i][k] == SquareStates.MARKED
			else:
				is_marked = map[k].has(i) and map[k][i] == SquareStates.MARKED

			if is_marked:
				count += 1
				total += 1
				segment.append(k)
			elif count > 0:
				master [HEADERS_KEY][axis][i].append({'length': str(count), 'segment': segment})
				count = 0
				segment = []
		if count > 0:
			master [HEADERS_KEY][axis][i].append({'length': str(count), 'segment': segment})
		if total == 0:
			master [HEADERS_KEY][axis][i].append({'length': str(count), 'segment': segment})

func cheat_reveal_all_squares():
	for i in SIZE.x:
		for k in SIZE.y:
			if master [TARGET_MAP_KEY][i].has(k) and master [TARGET_MAP_KEY][i][k] == SquareStates.MARKED:
				master [SQUARE_MAP_KEY][i][k] = SquareStates.MARKED
			else:
				master [SQUARE_MAP_KEY][i][k] = SquareStates.EMPTY

	board_ready.emit()