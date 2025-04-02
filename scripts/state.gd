extends Node

signal square_changed(coords)
signal board_ready
signal toggle_state_changed(new_state)
signal victory
signal notes_mode_changed(new_mode)
signal level_changed
signal coords_changed(coords)

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
var SQUARE_MAP_KEY := 'square_map'
var TARGET_MAP_KEY := 'target_map'
var HEADERS_KEY := 'headers'
var VICTORY_KEY := 'victory'
var SIZE_KEY := 'size'
var HEADERS_OVERRIDE_KEY := 'headers_override'
var FOOTER_KEY := 'footer'
var toggle_state: ToggleStates = ToggleStates.NOTHING
var notes: bool
var active_id: String = "default"

func setup(parameters: Dictionary) -> void:
	sanity_check_parameters(parameters)
	if (parameters.has('seed')):
		set_seed(parameters['seed'])
	else:
		randomize()
	if (parameters.has('size')):
		set_size(parameters['size'])
	if (parameters.has('notes')):
		notes = parameters['notes']
	if (parameters.has('id')):
		active_id = parameters['id']
	generate_target_map(parameters)
	prepare_square_map(parameters)
	if (parameters.has('complications')):
		master [active_id][HEADERS_OVERRIDE_KEY] = {}
		handle_complications(parameters['complications'])
	board_ready.emit()

func set_active_id(new_id: String):
	active_id = new_id
	if (! master.keys().has(active_id)):
		master [new_id] = {}
		if LevelLibrary.level_exists(new_id):
			setup(LevelLibrary.get_level_parameters(new_id))
	else:
		board_ready.emit()
	level_changed.emit()

func get_active_id() -> String:
	return active_id

func set_size(new_size: Vector2i):
	master [active_id][SIZE_KEY] = new_size

func get_size() -> Vector2i:
	if master.has(active_id) and master [active_id].has(SIZE_KEY):
		return master [active_id][SIZE_KEY]
	else:
		return Vector2i(0, 0)

func set_seed(new_seed: int):
	seed(new_seed)

func set_target_map(new_map: Dictionary):
	master [active_id][TARGET_MAP_KEY] = new_map

func set_chosen_coords(new_coords: Vector2i):
	chosen_coords = new_coords
	coords_changed.emit(new_coords)

func get_chosen_coords_state() -> SquareStates:
	return get_position_state(chosen_coords)

func get_position_state(coords: Vector2i) -> SquareStates:
	return master [active_id][SQUARE_MAP_KEY][coords.x][coords.y]

func get_board_ready() -> bool:
	return master [active_id].has(SQUARE_MAP_KEY) and master [active_id].has(TARGET_MAP_KEY)

func get_header(axis: String) -> Dictionary:
	var headers = master [active_id][HEADERS_KEY][axis].duplicate(true)
	if master [active_id].has(HEADERS_OVERRIDE_KEY):
		var headers_overrides = master [active_id][HEADERS_OVERRIDE_KEY]
		if headers_overrides.has(axis):
			for index in headers_overrides[axis].keys():
				var complication = headers_overrides[axis][index][-1]
				# get the last complication, save the rest for documentation
				headers[index] = complication
	return headers

func get_footer(axis: String) -> Dictionary:
	if master [active_id].has(FOOTER_KEY) and master [active_id][FOOTER_KEY].has(axis):
		return master [active_id][FOOTER_KEY][axis]
	else:
		return {}

func change_square_state(new_state: SquareStates):
	if (new_state == SquareStates.MARKED):
		if get_chosen_coords_state() == SquareStates.EMPTY:
			if (!notes):
				set_chosen_coords_state(SquareStates.MARKED)
			else:
				set_chosen_coords_state(SquareStates.NOTE_MARKED)
		if get_chosen_coords_state() == SquareStates.NOTE_MARKED:
			if (!notes):
				set_chosen_coords_state(SquareStates.MARKED)
	elif (new_state == SquareStates.FLAGGED):
		if get_chosen_coords_state() == SquareStates.EMPTY:
			if (!notes):
				set_chosen_coords_state(SquareStates.FLAGGED)
			else:
				set_chosen_coords_state(SquareStates.NOTE_FLAGGED)
		if get_chosen_coords_state() == SquareStates.NOTE_FLAGGED:
			if (!notes):
				set_chosen_coords_state(SquareStates.FLAGGED)
	elif (new_state == SquareStates.EMPTY):
		set_chosen_coords_state(SquareStates.EMPTY)
	square_changed.emit(chosen_coords)

func set_square_state(coords: Vector2i, new_state: SquareStates):
	master [active_id][SQUARE_MAP_KEY][coords.x][coords.y] = new_state
	square_changed.emit(coords)

func set_chosen_coords_state(new_state: SquareStates):
	set_square_state(chosen_coords, new_state)

func get_target_position(coords: Vector2i) -> SquareStates:
	var SIZE = get_size()
	if (coords.x < 0 || coords.x >= SIZE.x || coords.y < 0 || coords.y >= SIZE.y):
		printerr("Invalid position: ", coords.x, ", ", coords.y)
	return master [active_id][TARGET_MAP_KEY][coords.x][coords.y]

func set_target_position(coords: Vector2i, value: SquareStates):
	var SIZE = get_size()
	if (coords.x < 0 || coords.x >= SIZE.x || coords.y < 0 || coords.y >= SIZE.y):
		printerr("Invalid position: ", coords.x, ", ", coords.y)
	master [active_id][TARGET_MAP_KEY][coords.x][coords.y] = value

func set_notes_no_signal(value: bool):
	notes = value

func set_notes(value: bool):
	notes = value
	notes_mode_changed.emit(notes)

func get_notes() -> bool:
	return notes

func prepare_square_map(parameters: Dictionary):
	if master [active_id].has(SQUARE_MAP_KEY):
		print("Square map already exists")
		return
	elif parameters.has('square_map'):
		print("Square map supplied by parameters")
		set_square_map(parameters['square_map'])
	else:
		print("Generating square map")
		generate_empty_map()

func generate_empty_map():
	var SIZE = get_size()
	if (SIZE.x <= 0 || SIZE.y <= 0):
		printerr("Invalid map size: ", SIZE)
	master [active_id][SQUARE_MAP_KEY] = {}
	for i in SIZE.x:
		var column: Array[SquareStates] = []
		for k in SIZE.y:
			column.append(SquareStates.EMPTY)
		master [active_id][SQUARE_MAP_KEY][i] = column

func set_square_map(new_map: Dictionary):
	master [active_id][SQUARE_MAP_KEY] = new_map

func _process(_delta):
	if ! master.has(active_id):
		return
	if master [active_id].has(VICTORY_KEY) and master [active_id][VICTORY_KEY]:
		return
	handle_input_release()
	handle_note_press()
	if chosen_coords == Vector2i(-1, -1):
		return
	handle_input_press()

#region Input Handling
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
	if state == SquareStates.EMPTY || state == SquareStates.NOTE_MARKED:
		set_toggle_state(ToggleStates.MARKING)
	elif state == SquareStates.MARKED:
		set_toggle_state(ToggleStates.EMPTYING_MARKED)

func handle_flag_press(state: SquareStates):
	if state == SquareStates.EMPTY || state == SquareStates.NOTE_FLAGGED:
		set_toggle_state(ToggleStates.FLAGGING)
	elif state == SquareStates.FLAGGED:
		set_toggle_state(ToggleStates.EMPTYING_FLAGGED)

func handle_toggle_state():
	if toggle_state == ToggleStates.MARKING:
		change_square_state(SquareStates.MARKED)
	elif toggle_state == ToggleStates.EMPTYING_MARKED:
		if get_chosen_coords_state() == SquareStates.MARKED || get_chosen_coords_state() == SquareStates.NOTE_MARKED:
			change_square_state(SquareStates.EMPTY)
	elif toggle_state == ToggleStates.FLAGGING:
		change_square_state(SquareStates.FLAGGED)
	elif toggle_state == ToggleStates.EMPTYING_FLAGGED:
		if get_chosen_coords_state() == SquareStates.FLAGGED || get_chosen_coords_state() == SquareStates.NOTE_FLAGGED:
			change_square_state(SquareStates.EMPTY)

func reset_toggle_state():
	toggle_state = ToggleStates.NOTHING
	toggle_state_changed.emit(toggle_state)

func set_toggle_state(new_state: ToggleStates):
	toggle_state = new_state
	toggle_state_changed.emit(toggle_state)

func handle_note_press():
	if Input.is_action_just_pressed("Note"):
		set_notes(true)
	elif Input.is_action_just_released("Note"):
		set_notes(false)
#endregion Input Handling

#region Target Map Generation
func generate_target_map(parameters: Dictionary):
	random_center_map(parameters)
	generate_headers()

func random_center_map(_parameters: Dictionary):
	master [active_id][TARGET_MAP_KEY] = {}
	var SIZE = get_size()
	for i in SIZE.x:
		master [active_id][TARGET_MAP_KEY][i] = {}
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
#endregion Target Map Generation

#region Cheats
func interpret_command(command: String) -> void:
	match command:
		"reveal_all":
			cheat_reveal_all_squares()
		_:
			print("Unknown command: ", command)

func cheat_reveal_all_squares():
	var SIZE = get_size()
	for i in SIZE.x:
		for k in SIZE.y:
			var position = Vector2i(i, k)
			if get_target_position(position) == SquareStates.MARKED:
				set_square_state(position, SquareStates.MARKED)
			else:
				set_square_state(position, SquareStates.EMPTY)

	board_ready.emit()
#endregion Cheats

func generate_headers():
	master [active_id][HEADERS_KEY] = {}
	var map = master [active_id][TARGET_MAP_KEY]
	var SIZE = get_size()
	
	generate_header_for_axis('X', SIZE.x, SIZE.y, map)
	generate_header_for_axis('Y', SIZE.y, SIZE.x, map)

#region Danger Square Detection
func cleanup_danger_segments():
	var x_offset_segments = find_offset_by_one_segments('X')
	var y_offset_segments = find_offset_by_one_segments('Y')
	var danger_segments = find_shared_end_segments(x_offset_segments, y_offset_segments)
	var changed_points = resolve_danger_square(danger_segments)
	update_headers_for_points(changed_points)

func generate_header_for_axis(axis: String, primary_size: int, secondary_size: int, map: Dictionary):
	master [active_id][HEADERS_KEY][axis] = {}
	for i in primary_size:
		var total = 0
		var count = 0
		var segment = []
		master [active_id][HEADERS_KEY][axis][i] = []
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
				master [active_id][HEADERS_KEY][axis][i].append({'length': str(count), 'segment': segment})
				count = 0
				segment = []
		if count > 0:
			master [active_id][HEADERS_KEY][axis][i].append({'length': str(count), 'segment': segment})
		if total == 0:
			master [active_id][HEADERS_KEY][axis][i].append({'length': str(count), 'segment': segment})

func get_duplicate_lengths(axis: String) -> Dictionary:
	var seen_lengths = {}
	var duplicate_lengths = {}
	for i in master [active_id][HEADERS_KEY][axis]:
		for k in master [active_id][HEADERS_KEY][axis][i]:
			var length = k['length']
			if (length == '0'):
				continue
			if seen_lengths.has(length):
				if not duplicate_lengths.has(length):
					duplicate_lengths[length] = [seen_lengths[length]]
				duplicate_lengths[length].append({'x': i, 'segment': k['segment']})
			else:
				seen_lengths[length] = {'x': i, 'segment': k['segment']}
	return duplicate_lengths

func find_offset_by_one_segments(axis: String) -> Array:
	var duplicate_lengths = get_duplicate_lengths(axis)
	var offset_segments = []

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
						offset_segments.append({
							'segment1': segment1,
							'segment2': segment2,
							'index1': segments[i]['x'],
							'index2': segments[j]['x']
						})

	return offset_segments

func find_shared_end_segments(offset_segments_x: Array, offset_segments_y: Array) -> Array:
	var shared_end_segments = []

	for x_pair in offset_segments_x:
		var ends_list_x = []
		var empty_list_x = []
		if (x_pair['segment2'].has(x_pair['segment1'][0])):
			# if the first point of segment 1 is in segment 2, then the last point of segment 1 is the potentially shared point
			var point1 = Vector2i(x_pair['index1'], x_pair['segment1'][-1])
			var point2 = Vector2i(x_pair['index2'], x_pair['segment2'][0])
			ends_list_x = [point1, point2]
			empty_list_x = [Vector2i(x_pair['index2'], x_pair['segment1'][-1]),
							Vector2i(x_pair['index1'], x_pair['segment2'][0])]
		else:
			# There must be overhang, because they are offset by one and the first point of segment 1 is not in segment 2
			# So the first point of segment 1 is the potentially shared point
			var point1 = Vector2i(x_pair['index1'], x_pair['segment1'][0])
			var point2 = Vector2i(x_pair['index2'], x_pair['segment2'][-1])
			ends_list_x = [point1, point2]
			empty_list_x = [Vector2i(x_pair['index1'], x_pair['segment2'][-1]),
							Vector2i(x_pair['index2'], x_pair['segment1'][0])]
		
		var adjacent_points = [
			Vector2i(empty_list_x[0].x, empty_list_x[0].y),
			Vector2i(empty_list_x[0].x - 1, empty_list_x[0].y),
			Vector2i(empty_list_x[0].x + 1, empty_list_x[0].y),
			Vector2i(empty_list_x[0].x, empty_list_x[0].y - 1),
			Vector2i(empty_list_x[0].x, empty_list_x[0].y + 1),
			Vector2i(empty_list_x[1].x, empty_list_x[1].y),
			Vector2i(empty_list_x[1].x - 1, empty_list_x[1].y),
			Vector2i(empty_list_x[1].x + 1, empty_list_x[1].y),
			Vector2i(empty_list_x[1].x, empty_list_x[1].y - 1),
			Vector2i(empty_list_x[1].x, empty_list_x[1].y + 1)
		]
		
		var collated_segment_points = []
		for y in x_pair['segment1']:
			var point = Vector2i(x_pair['index1'], y)
			if (point not in collated_segment_points):
				collated_segment_points.append(point)
		for y in x_pair['segment2']:
			var point = Vector2i(x_pair['index2'], y)
			if (point not in collated_segment_points):
				collated_segment_points.append(point)

		var adjacency_exception = false
		for point in adjacent_points:
			var SIZE = get_size()
			if point.x >= 0 and point.x < SIZE.x and point.y >= 0 and point.y < SIZE.y:
				if point not in collated_segment_points:
					if get_target_position(point) == SquareStates.MARKED:
						adjacency_exception = true
						break
		if adjacency_exception:
			continue

		for y_pair in offset_segments_y:
			var ends_list_y = []
			if (y_pair['segment2'].has(y_pair['segment1'][0])):
				# The same logic as above, but for the y axis
				var point1 = Vector2i(y_pair['segment1'][-1], y_pair['index1'])
				var point2 = Vector2i(y_pair['segment2'][0], y_pair['index2'])
				ends_list_y = [point1, point2]
			else:
				var point1 = Vector2i(y_pair['segment1'][0], y_pair['index1'])
				var point2 = Vector2i(y_pair['segment2'][-1], y_pair['index2'])
				ends_list_y = [point1, point2]

			if (ends_list_x[0] == ends_list_y[0] and ends_list_x[1] == ends_list_y[1]):
				shared_end_segments.append({'x': x_pair, 'y': y_pair, 'unmarked_corners': empty_list_x})
			elif (ends_list_x[0] == ends_list_y[1] and ends_list_x[1] == ends_list_y[0]):
				shared_end_segments.append({'x': x_pair, 'y': y_pair, 'unmarked_corners': empty_list_x})

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
				var SIZE = get_size()
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

#endregion Danger Square Detection

#region Header Reprocessing
func update_header_for_row(row: int):
	var map = master [active_id][TARGET_MAP_KEY]
	var total = 0
	var count = 0
	var segment = []
	master [active_id][HEADERS_KEY]['X'][row] = []
	var SIZE = get_size()
	for k in range(SIZE.y):
		var is_marked = map.has(row) and map[row].has(k) and map[row][k] == SquareStates.MARKED

		if is_marked:
			count += 1
			total += 1
			segment.append(k)
		elif count > 0:
			master [active_id][HEADERS_KEY]['X'][row].append({'length': str(count), 'segment': segment})
			count = 0
			segment = []
	if count > 0:
		master [active_id][HEADERS_KEY]['X'][row].append({'length': str(count), 'segment': segment})
	if total == 0:
		master [active_id][HEADERS_KEY]['X'][row].append({'length': str(count), 'segment': segment})

func update_header_for_column(column: int):
	var map = master [active_id][TARGET_MAP_KEY]
	var total = 0
	var count = 0
	var segment = []
	master [active_id][HEADERS_KEY]['Y'][column] = []
	var SIZE = get_size()
	for i in range(SIZE.x):
		var is_marked = map.has(i) and map[i].has(column) and map[i][column] == SquareStates.MARKED

		if is_marked:
			count += 1
			total += 1
			segment.append(i)
		elif count > 0:
			master [active_id][HEADERS_KEY]['Y'][column].append({'length': str(count), 'segment': segment})
			count = 0
			segment = []
	if count > 0:
		master [active_id][HEADERS_KEY]['Y'][column].append({'length': str(count), 'segment': segment})
	if total == 0:
		master [active_id][HEADERS_KEY]['Y'][column].append({'length': str(count), 'segment': segment})
#endregion Header Reprocessing

func sanity_check_parameters(parameters: Dictionary) -> bool:
	if parameters.has('size'):
		var size = parameters['size']
		if parameters.has('target_map'):
			var target_map = parameters['target_map']
			for x in target_map.keys():
				if x >= size.x:
					printerr("Target map x dimension exceeds size.x")
					return false
				for y in target_map[x].keys():
					if y >= size.y:
						printerr("Target map y dimension exceeds size.y")
						return false
		if parameters.has('square_map'):
			var square_map = parameters['square_map']
			for x in square_map.keys():
				if x >= size.x:
					printerr("Square map x dimension exceeds size.x")
					return false
				for y in square_map[x].keys():
					if y >= size.y:
						printerr("Square map y dimension exceeds size.y")
						return false
	return true

func check_victory() -> bool:
	var SIZE = get_size()
	for x in range(SIZE.x):
		for y in range(SIZE.y):
			var coords = Vector2i(x, y)
			var target_state = get_target_position(coords)
			var current_state = get_position_state(coords)
			if target_state == SquareStates.MARKED and current_state != SquareStates.MARKED:
				return false
			elif target_state != SquareStates.MARKED and (current_state == SquareStates.MARKED or
			current_state == SquareStates.NOTE_MARKED):
				return false
	return true

func submit():
	if check_victory():
		set_victory()
		victory.emit()

#region Victory Handling
func set_victory():
	if ! master [active_id].has(VICTORY_KEY):
		master [active_id][VICTORY_KEY] = true

func get_victory_count() -> int:
	var count = 0
	for id in master.keys():
		if master [id].has(VICTORY_KEY) and master [id][VICTORY_KEY]:
			count += 1
	return count

func get_victory_state() -> bool:
	return master [active_id].has(VICTORY_KEY) and master [active_id][VICTORY_KEY]
#endregion Victory Handling

#region Level Change Management
func next_level():
	var level = LevelLibrary.get_level(active_id)
	if (level.has('next')):
		set_active_id(level.next)

func prev_level():
	var level = LevelLibrary.get_level(active_id)
	if (level.has('prev')):
		set_active_id(level.prev)

func has_next_level():
	var level = LevelLibrary.get_level(active_id)
	return level.has('next')

func has_prev_level():
	var level = LevelLibrary.get_level(active_id)
	return level.has('prev')
#endregion Level Change Management

#region Complications
func handle_complications(list: Array):
	for i in list:
		if i.has('type'):
			match i['type']:
				"delta":
					handle_delta_complication(i)
				_:
					print("Unknown complication type: ", i['type'])

func handle_delta_complication(complication: Dictionary):
	generate_delta_header(complication)
	generate_delta_footer(complication)

func generate_delta_header(complication: Dictionary):
	var subject_axis = 'X' if complication.has('subject_index') else 'Y'
	var subject_index = complication['subject_column'] if subject_axis == 'X' else complication['subject_row']
	if (! master [active_id][HEADERS_OVERRIDE_KEY].has(subject_axis)):
		master [active_id][HEADERS_OVERRIDE_KEY][subject_axis] = {}
	if (! master [active_id][HEADERS_OVERRIDE_KEY][subject_axis].has(subject_index)):
		master [active_id][HEADERS_OVERRIDE_KEY][subject_axis][subject_index] = []
	var variable_axis = 'X' if complication.has('variable_column') else 'Y'
	var variable_index = complication['variable_column'] if variable_axis == 'X' else complication['variable_row']

	var complication_header = generate_delta(
		master [active_id][HEADERS_KEY][subject_axis][subject_index],
		master [active_id][HEADERS_KEY][variable_axis][variable_index]
	)

	master [active_id][HEADERS_OVERRIDE_KEY][subject_axis][subject_index].append(complication_header)

func generate_delta_footer(complication: Dictionary):
	var subject_axis = 'X' if complication.has('subject_column') else 'Y'
	var subject_index = complication['subject_column'] if subject_axis == 'X' else complication['subject_row']
	var complication_abbreviation = "Δ"
	var complication_variable: String
	if (complication.has('variable_column')):
		complication_variable = str('c', subject_index + 1)
	elif (complication.has('variable_row')):
		complication_variable = str('r', subject_index + 1)
	
	var complication_footer = str(
		complication_abbreviation,
		complication_variable
		)
	if not master [active_id].has(FOOTER_KEY):
		master [active_id][FOOTER_KEY] = {}
	if not master [active_id][FOOTER_KEY].has(subject_axis):
		master [active_id][FOOTER_KEY][subject_axis] = {}
	if not master [active_id][FOOTER_KEY][subject_axis].has(subject_index):
		master [active_id][FOOTER_KEY][subject_axis][subject_index] = [complication_footer]
	else:
		master [active_id][FOOTER_KEY][subject_axis][subject_index].append(complication_footer)


func generate_delta(headers1: Array, headers2: Array) -> Array:
	var delta = []
	var i = 0
	var j = 0
	var k = 0
	var count = 0
	var segment = []

	while i < headers1.size() and j < headers2.size():
		if k > headers1[i]['segment'][-1]:
			i += 1
			if i >= headers1.size():
				break
		if k > headers2[j]['segment'][-1]:
			j += 1
			if j >= headers2.size():
				break
		
		if (headers1[i]['segment'].has(k) or headers2[j]['segment'].has(k)):
			if not (headers1[i]['segment'].has(k) and headers2[j]['segment'].has(k)):
				segment.append(k)
				count += 1
			else:
				if (count > 0):
					delta.append({'length': str(count), 'segment': segment})
					count = 0
					segment = []
		else:
			if (count > 0):
				delta.append({'length': str(count), 'segment': segment})
				count = 0
				segment = []

		k += 1
	
	while i < headers1.size():
		if (headers1[i]['segment'].has(k)):
			segment.append(k)
			count += 1
		else:
			if (count > 0):
				delta.append({'length': str(count), 'segment': segment})
				count = 0
				segment = []
		k += 1
		if k > headers1[i]['segment'][-1]:
			i += 1
	
	while j < headers2.size():
		if (headers2[j]['segment'].has(k)):
			segment.append(k)
			count += 1
		else:
			if (count > 0):
				delta.append({'length': str(count), 'segment': segment})
				count = 0
				segment = []
		k += 1
		if k > headers2[j]['segment'][-1]:
			j += 1
	
	if (count > 0):
		delta.append({'length': str(count), 'segment': segment})
		count = 0
		segment = []

	return delta

	
#endregion Complications
