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

func _ready() -> void:
	generate_empty_map()
	generate_target_map()

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

func generate_target_map():
	random_center_map()
	generate_headers()

func random_center_map():
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
	print('danger_segments ', danger_segments)

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
		if (segment_pair_x['segment2'].has(segment_pair_x['segment1'][0])):
			var point1 = Vector2i(segment_pair_x['index1'], segment_pair_x['segment1'][-1])
			var point2 = Vector2i(segment_pair_x['index2'], segment_pair_x['segment2'][0])
			ends_list_x.append({'point1': point1, 'point2': point2})
		else:
			var point1 = Vector2i(segment_pair_x['index1'], segment_pair_x['segment1'][0])
			var point2 = Vector2i(segment_pair_x['index2'], segment_pair_x['segment2'][-1])
			ends_list_x.append({'point1': point1, 'point2': point2})

		var adjacent_exception := false

		for end in ends_list_x:
			if (adjacent_exception):
				break
			var adjacent_points = [
				Vector2i(end['point1'].x - 1, end['point1'].y),
				Vector2i(end['point1'].x + 1, end['point1'].y),
				Vector2i(end['point1'].x, end['point1'].y - 1),
				Vector2i(end['point1'].x, end['point1'].y + 1),
				Vector2i(end['point2'].x - 1, end['point2'].y),
				Vector2i(end['point2'].x + 1, end['point2'].y),
				Vector2i(end['point2'].x, end['point2'].y - 1),
				Vector2i(end['point2'].x, end['point2'].y + 1)
			]

			for point in adjacent_points:
				if point.x >= 0 and point.x < SIZE.x and point.y >= 0 and point.y < SIZE.y:
					if get_target_position(point) != SquareStates.MARKED or (point in segment_pair_x['segment1'] or point in segment_pair_x['segment2']):
						adjacent_exception = true
						break
		if (adjacent_exception):
			continue

		for key_y in offset_segments_y.keys():
			var segment_pair_y = offset_segments_y[key_y]
			var ends_list_y = []
			if (segment_pair_y['segment2'].has(segment_pair_y['segment1'][0])):
				var point1 = Vector2i(segment_pair_y['index1'], segment_pair_y['segment1'][-1])
				var point2 = Vector2i(segment_pair_y['index2'], segment_pair_y['segment2'][0])
				ends_list_y.append({'point1': point1, 'point2': point2})
			else:
				var point1 = Vector2i(segment_pair_y['index1'], segment_pair_y['segment1'][0])
				var point2 = Vector2i(segment_pair_y['index2'], segment_pair_y['segment2'][-1])
				ends_list_y.append({'point1': point1, 'point2': point2})

			if (ends_list_x[0]['point1'] == ends_list_y[0]['point1'] and ends_list_x[0]['point2'] == ends_list_y[0]['point2']):
				shared_end_segments.append({'point1': ends_list_x[0]['point1'], 'point2': ends_list_x[0]['point2']})
			elif (ends_list_x[0]['point1'] == ends_list_y[0]['point2'] and ends_list_x[0]['point2'] == ends_list_y[0]['point1']):
				shared_end_segments.append({'point1': ends_list_x[0]['point1'], 'point2': ends_list_x[0]['point2']})


	return shared_end_segments
