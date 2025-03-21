extends Node

signal square_changed(coords)
signal board_ready
signal toggle_state_changed(new_state)

enum SquareStates {
	EMPTY,
	MARKED,
	NOTE_MARKED,
	FLAGGED,
	NOTE_FLAGGED,
}

enum ToggleStates {
	NOTHING,
	MARKING,
	EMPTYING_MARKED,
	FLAGGING,
	EMPTYING_FLAGGED,
}

var chosen_coords: Vector2i = Vector2i(-1, -1)
var master: Dictionary
var SIZE := Vector2i(8, 8)
var SQUARE_MAP_KEY := 'square_map'
var TARGET_MAP_KEY := 'target_map'
var HEADERS_KEY := 'headers'
var toggle_state: ToggleStates = ToggleStates.NOTHING

func setup(parameters: Dictionary) -> void:
	if (parameters.has('seed')):
		seed(parameters['seed'])
	else:
		randomize()
	if (parameters.has('size')):
		SIZE = parameters['size']
	generate_empty_map()
	generate_target_map(parameters)

func set_chosen_coords(new_coords: Vector2i):
	chosen_coords = new_coords

func get_chosen_coords_state() -> SquareStates:
	return get_position_state(chosen_coords)

func get_position_state(coords: Vector2i) -> SquareStates:
	return master [SQUARE_MAP_KEY][coords.x][coords.y]

func change_square_state(new_state: SquareStates):
	if (new_state == SquareStates.MARKED):
		if (get_chosen_coords_state() == SquareStates.EMPTY):
			set_chosen_coords_state(SquareStates.MARKED)
	elif (new_state == SquareStates.FLAGGED):
		if (get_chosen_coords_state() == SquareStates.EMPTY):
			set_chosen_coords_state(SquareStates.FLAGGED)
	elif (new_state == SquareStates.EMPTY):
		set_chosen_coords_state(SquareStates.EMPTY)
	square_changed.emit(chosen_coords)

func set_square_state(coords: Vector2i, new_state: SquareStates):
	master [SQUARE_MAP_KEY][coords.x][coords.y] = new_state
	square_changed.emit(coords)

func set_chosen_coords_state(new_state: SquareStates):
	set_square_state(chosen_coords, new_state)

func get_target_position(coords: Vector2i) -> SquareStates:
	if (coords.x < 0 || coords.x >= SIZE.x || coords.y < 0 || coords.y >= SIZE.y):
		printerr("Invalid position: ", coords.x, ", ", coords.y)
	return master [TARGET_MAP_KEY][coords.x][coords.y]

func set_target_position(coords: Vector2i, value: SquareStates):
	if (coords.x < 0 || coords.x >= SIZE.x || coords.y < 0 || coords.y >= SIZE.y):
		printerr("Invalid position: ", coords.x, ", ", coords.y)
	master [TARGET_MAP_KEY][coords.x][coords.y] = value

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
	handle_input_release()
	if chosen_coords == Vector2i(-1, -1):
		return
	handle_input_press()

func handle_input_release():
	if Input.is_action_just_released("Mark") and (toggle_state == ToggleStates.MARKING or toggle_state == ToggleStates.EMPTYING_MARKED):
		reset_toggle_state()
	elif Input.is_action_just_released("Flag") and (toggle_state == ToggleStates.FLAGGING or toggle_state == ToggleStates.EMPTYING_FLAGGED):
		reset_toggle_state()

func handle_input_press():
	var state = get_chosen_coords_state()
	if toggle_state == ToggleStates.NOTHING:
		if Input.is_action_just_pressed("Mark"):
			handle_mark_press(state)
		elif Input.is_action_just_pressed("Flag"):
			handle_flag_press(state)
	handle_toggle_state()

func handle_mark_press(state: SquareStates):
	if state == SquareStates.EMPTY:
		set_toggle_state(ToggleStates.MARKING)
	elif state == SquareStates.MARKED:
		set_toggle_state(ToggleStates.EMPTYING_MARKED)

func handle_flag_press(state: SquareStates):
	if state == SquareStates.EMPTY:
		set_toggle_state(ToggleStates.FLAGGING)
	elif state == SquareStates.FLAGGED:
		set_toggle_state(ToggleStates.EMPTYING_FLAGGED)

func handle_toggle_state():
	if toggle_state == ToggleStates.MARKING:
		change_square_state(SquareStates.MARKED)
	elif toggle_state == ToggleStates.EMPTYING_MARKED:
		change_square_state(SquareStates.EMPTY)
	elif toggle_state == ToggleStates.FLAGGING:
		change_square_state(SquareStates.FLAGGED)
	elif toggle_state == ToggleStates.EMPTYING_FLAGGED:
		change_square_state(SquareStates.EMPTY)

func reset_toggle_state():
	toggle_state = ToggleStates.NOTHING
	toggle_state_changed.emit(toggle_state)

func set_toggle_state(new_state: ToggleStates):
	toggle_state = new_state
	toggle_state_changed.emit(toggle_state)

func generate_target_map(parameters: Dictionary):
	random_center_map(parameters)
	generate_headers()

func random_center_map(_parameters: Dictionary):
	master [TARGET_MAP_KEY] = {}
	for i in SIZE.x:
		master [TARGET_MAP_KEY][i] = {}
		for k in SIZE.y:
			var average = roundi((SIZE.x + SIZE.y) / 2.0)
			var random_value = randf_range(-2.5, 2.5)
			var sum = absi(i - roundi(average / 2.0)) + absi(k - roundi(average / 2.0))
			sum += random_value
			var marked = sum < roundi(average / 1.95)
			if (marked):
				set_target_position(Vector2i(i, k), SquareStates.MARKED)
			else:
				set_target_position(Vector2i(i, k), SquareStates.EMPTY)

func generate_headers():
	master [HEADERS_KEY] = {}
	master [HEADERS_KEY]['X'] = {}
	master [HEADERS_KEY]['Y'] = {}
	var map = master [TARGET_MAP_KEY]
	
	generate_header_for_axis('X', SIZE.x, SIZE.y, map)
	generate_header_for_axis('Y', SIZE.y, SIZE.x, map)
	var x_offset_segments = find_offset_by_one_segments('X')
	var y_offset_segments = find_offset_by_one_segments('Y')
	var danger_segments = find_shared_end_segments(x_offset_segments, y_offset_segments)
	var changed_points = resolve_danger_square(danger_segments)
	update_headers_for_points(changed_points)

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
			var position = Vector2i(i, k)
			if get_target_position(position) == SquareStates.MARKED:
				set_square_state(position, SquareStates.MARKED)
			else:
				set_square_state(position, SquareStates.EMPTY)

	board_ready.emit()

func get_duplicate_lengths(axis: String) -> Dictionary:
	var seen_lengths = {}
	var duplicate_lengths = {}
	for i in master [HEADERS_KEY][axis]:
		for k in master [HEADERS_KEY][axis][i]:
			var length = k['length']
			if seen_lengths.has(length):
				if not duplicate_lengths.has(length):
					duplicate_lengths[length] = [seen_lengths[length]]
				duplicate_lengths[length].append({'x': i, 'segment': k['segment']})
			else:
				seen_lengths[length] = {'x': i, 'segment': k['segment']}
	return duplicate_lengths

func find_offset_by_one_segments(axis: String) -> Dictionary:
	var duplicate_lengths = get_duplicate_lengths(axis)
	var offset_segments = {}

	for length in duplicate_lengths.keys():
		var segments = duplicate_lengths[length]
		for i in range(segments.size()):
			for j in range(i + 1, segments.size()):
				var segment1 = segments[i]['segment']
				var segment2 = segments[j]['segment']
				if segment1.size() == segment2.size():
					var offset = true
					for k in range(segment1.size()):
						if abs(segment1[k] - segment2[k]) != 1:
							offset = false
							break
					if offset:
						var key = str(length) + "_" + str(segments[i]['x']) + "_" + str(segments[j]['x'])
						offset_segments[key] = {
							'segment1': segment1,
							'segment2': segment2,
							'index1': segments[i]['x'],
							'index2': segments[j]['x']
						}

	return offset_segments

func find_shared_end_segments(offset_segments_x: Dictionary, offset_segments_y: Dictionary) -> Array:
	var shared_end_segments = []

	for key_x in offset_segments_x.keys():
		var segment_pair_x = offset_segments_x[key_x]
		var ends_list_x = []
		var empty_list_x = []
		if (segment_pair_x['segment2'].has(segment_pair_x['segment1'][0])):
			# if the first point of segment 1 is in segment 2, then the last point of segment 1 is the potentially shared point
			var point1 = Vector2i(segment_pair_x['index1'], segment_pair_x['segment1'][-1])
			var point2 = Vector2i(segment_pair_x['index2'], segment_pair_x['segment2'][0])
			ends_list_x = [point1, point2]
			empty_list_x = [Vector2i(segment_pair_x['index2'], segment_pair_x['segment1'][-1]),
							Vector2i(segment_pair_x['index1'], segment_pair_x['segment2'][0])]
		else:
			# There must be overhang, because they are offset by one and the first point of segment 1 is not in segment 2
			# So the first point of segment 1 is the potentially shared point
			var point1 = Vector2i(segment_pair_x['index1'], segment_pair_x['segment1'][0])
			var point2 = Vector2i(segment_pair_x['index2'], segment_pair_x['segment2'][-1])
			ends_list_x = [point1, point2]
			empty_list_x = [Vector2i(segment_pair_x['index1'], segment_pair_x['segment2'][-1]),
							Vector2i(segment_pair_x['index2'], segment_pair_x['segment1'][0])]

		for key_y in offset_segments_y.keys():
			var segment_pair_y = offset_segments_y[key_y]
			var ends_list_y = []
			if (segment_pair_y['segment2'].has(segment_pair_y['segment1'][0])):
				# The same logic as above, but for the y axis
				var point1 = Vector2i(segment_pair_y['segment1'][-1], segment_pair_y['index1'])
				var point2 = Vector2i(segment_pair_y['segment2'][0], segment_pair_y['index2'])
				ends_list_y = [point1, point2]
			else:
				var point1 = Vector2i(segment_pair_y['segment1'][0], segment_pair_y['index1'])
				var point2 = Vector2i(segment_pair_y['segment2'][-1], segment_pair_y['index2'])
				ends_list_y = [point1, point2]

			if (ends_list_x[0] == ends_list_y[0] and ends_list_x[1] == ends_list_y[1]):
				shared_end_segments.append({'x': offset_segments_x[key_x], 'y': offset_segments_y[key_y], 'unmarked_corners': empty_list_x})
			elif (ends_list_x[0] == ends_list_y[1] and ends_list_x[1] == ends_list_y[0]):
				shared_end_segments.append({'x': offset_segments_x[key_x], 'y': offset_segments_y[key_y], 'unmarked_corners': empty_list_x})

	return shared_end_segments

func resolve_danger_square(cases: Array) -> Array:
	if cases.size() == 0:
		return []

	var changed_points = []
	for case in cases:
		var action = randi() % 2
		if action == 0:
			var unmarked_corners = case['unmarked_corners']
			
			var adjacent_points = [
				Vector2i(unmarked_corners[0].x, unmarked_corners[0].y),
				Vector2i(unmarked_corners[0].x - 1, unmarked_corners[0].y),
				Vector2i(unmarked_corners[0].x + 1, unmarked_corners[0].y),
				Vector2i(unmarked_corners[0].x, unmarked_corners[0].y - 1),
				Vector2i(unmarked_corners[0].x, unmarked_corners[0].y + 1),
				Vector2i(unmarked_corners[1].x, unmarked_corners[1].y),
				Vector2i(unmarked_corners[1].x - 1, unmarked_corners[1].y),
				Vector2i(unmarked_corners[1].x + 1, unmarked_corners[1].y),
				Vector2i(unmarked_corners[1].x, unmarked_corners[1].y - 1),
				Vector2i(unmarked_corners[1].x, unmarked_corners[1].y + 1)
			]
			
			var valid_points = []
			for point in adjacent_points:
				if point.x >= 0 and point.x < SIZE.x and point.y >= 0 and point.y < SIZE.y:
					if get_target_position(point) == SquareStates.EMPTY:
						valid_points.append(point)

			if valid_points.size() > 0:
				var random_point = valid_points[randi() % valid_points.size()]
				set_target_position(random_point, SquareStates.MARKED)
				changed_points.append(random_point)
		else:
			var axis = randi() % 2
			var random_segment
			var random_point
			if axis == 0:
				if (randi() % 2 == 0):
					random_segment = case['x']['segment1']
					random_point = Vector2i(case['x']['index1'], random_segment[randi() % random_segment.size()])
				else:
					random_segment = case['x']['segment2']
					random_point = Vector2i(case['x']['index2'], random_segment[randi() % random_segment.size()])
			else:
				if (randi() % 2 == 0):
					random_segment = case['y']['segment1']
					random_point = Vector2i(case['y']['index1'], random_segment[randi() % random_segment.size()])
				else:
					random_segment = case['y']['segment2']
					random_point = Vector2i(case['y']['index2'], random_segment[randi() % random_segment.size()])
			set_target_position(random_point, SquareStates.EMPTY)
			changed_points.append(random_point)

	return changed_points

func update_headers_for_points(points: Array):
	var processed_rows = {}
	var processed_columns = {}

	for point in points:
		var row = point.x
		var column = point.y

		if not processed_rows.has(row):
			update_header_for_row(row)
			processed_rows[row] = true

		if not processed_columns.has(column):
			update_header_for_column(column)
			processed_columns[column] = true

func update_header_for_row(row: int):
	var map = master [TARGET_MAP_KEY]
	var total = 0
	var count = 0
	var segment = []
	master [HEADERS_KEY]['X'][row] = []
	for k in range(SIZE.y):
		var is_marked = map.has(row) and map[row].has(k) and map[row][k] == SquareStates.MARKED

		if is_marked:
			count += 1
			total += 1
			segment.append(k)
		elif count > 0:
			master [HEADERS_KEY]['X'][row].append({'length': str(count), 'segment': segment})
			count = 0
			segment = []
	if count > 0:
		master [HEADERS_KEY]['X'][row].append({'length': str(count), 'segment': segment})
	if total == 0:
		master [HEADERS_KEY]['X'][row].append({'length': str(count), 'segment': segment})

func update_header_for_column(column: int):
	var map = master [TARGET_MAP_KEY]
	var total = 0
	var count = 0
	var segment = []
	master [HEADERS_KEY]['Y'][column] = []
	for i in range(SIZE.x):
		var is_marked = map.has(i) and map[i].has(column) and map[i][column] == SquareStates.MARKED

		if is_marked:
			count += 1
			total += 1
			segment.append(i)
		elif count > 0:
			master [HEADERS_KEY]['Y'][column].append({'length': str(count), 'segment': segment})
			count = 0
			segment = []
	if count > 0:
		master [HEADERS_KEY]['Y'][column].append({'length': str(count), 'segment': segment})
	if total == 0:
		master [HEADERS_KEY]['Y'][column].append({'length': str(count), 'segment': segment})
