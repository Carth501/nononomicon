extends Node

signal square_changed(coords)
signal board_ready
signal toggle_state_changed(new_state)
signal victory_changed(victory)
signal notes_mode_changed(new_mode)
signal level_changed
signal coords_changed(coords)
signal error_lines_updated(errors)
signal stack_changed
signal lines_compared(comparison)
signal lock_added_to_square(coords)
signal locks_cleared
signal showing_power(power_id)
signal hiding_power()
signal powers_changed()
signal power_charge_used(power_id)
signal hint_display_changed
signal drag_begun
signal drag_length_changed(length)
signal drag_ended

enum SquareStates {
	EMPTY,
	MARKED,
	NOTE_MARKED,
	FLAGGED,
	NOTE_FLAGGED,
	INVALID
}

enum ToggleStates {
	NOTHING,
	MARKING,
	EMPTYING_MARKED,
	FLAGGING,
	EMPTYING_FLAGGED,
}

enum Axis {
	NONE,
	X,
	Y
}

var chosen_coords: Vector2i = Vector2i(-1, -1)
var master: Dictionary
var SQUARE_MAP_KEY := 'square_map'
var TARGET_MAP_KEY := 'target_map'
var HEADERS_KEY := 'headers'
var VICTORY_KEY := 'victory'
var STACK_KEY := 'stack'
var STACK_INDEX_KEY := 'stack_index'
var SIZE_KEY := 'size'
var HEADERS_OVERRIDE_KEY := 'headers_override'
var FOOTER_KEY := 'footer'
var COMPLICATIONS_KEY := 'complications'
var LOCKS_KEY := 'locks'
var POWERS_KEY := 'powers'
var HINTS_KEY := 'hints'
var toggle_state: ToggleStates = ToggleStates.NOTHING
var notes: bool
var active_id: String = "default"
var drag_direction: Axis = Axis.NONE
var drag_start := Vector2i(-1, -1)
var drag_min: int = -1
var drag_max: int = -1
var power_id: String = ""
var hint_display: Array = []

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
	if (parameters.has('hints')):
		set_hints(parameters['hints'])
	if parameters.has('powers'):
		set_powers(parameters['powers'])
	generate_target_map(parameters)
	prepare_square_map(parameters)
	if (parameters.has('complications')):
		master [active_id][HEADERS_OVERRIDE_KEY] = {}
		handle_complications(parameters['complications'])
	board_ready.emit()
	if (parameters.has('locks')):
		for coords in parameters.locks:
			lock_square(coords)

func new_game():
	master = {}
	active_id = "default"

func load_save(save: Dictionary):
	for level in save.keys():
		master [level] = {}
		active_id = level
		setup(LevelLibrary.get_level_parameters(level))
		if (save[level].has(SQUARE_MAP_KEY)): # it would be weird for this to be missing
			master [level][SQUARE_MAP_KEY] = save[level][SQUARE_MAP_KEY]
		else:
			push_warning("Missing square map for level: ", level)
		if (save[level].has(VICTORY_KEY)):
			master [level][VICTORY_KEY] = save[level][VICTORY_KEY]
		if (save[level].has(STACK_KEY)):
			master [level][STACK_KEY] = save[level][STACK_KEY]
		if save[level].has(LOCKS_KEY):
			for coords in save[level].get(LOCKS_KEY, {}):
				lock_square(coords)
		if master [level].has(POWERS_KEY) and save[level].has(POWERS_KEY):
			for power in master [level][POWERS_KEY].keys():
				if save[level][POWERS_KEY].has(power):
					master [level][POWERS_KEY][power]["charges"] = save[level][POWERS_KEY][power]["charges"]

func get_trimmed_master() -> Dictionary:
	var trimmed_master = {}
	for level in master.keys():
		trimmed_master[level] = {}
		trimmed_master[level][SQUARE_MAP_KEY] = master [level][SQUARE_MAP_KEY]
		if (master [level].has(STACK_KEY)):
			trimmed_master[level][STACK_KEY] = master [level][STACK_KEY]
		if (master [level].has(LOCKS_KEY)):
			trimmed_master[level][LOCKS_KEY] = master [level][LOCKS_KEY]
		if (master [level].has(POWERS_KEY)):
			trimmed_master[level][POWERS_KEY] = master [level][POWERS_KEY]
		if (master [level].has(VICTORY_KEY)):
			trimmed_master[level][VICTORY_KEY] = master [level][VICTORY_KEY]
	return trimmed_master

func set_active_id(new_id: String):
	active_id = new_id
	if (! master.keys().has(active_id)):
		master [new_id] = {}
		if LevelLibrary.level_exists(new_id):
			setup(LevelLibrary.get_level_parameters(new_id))
	else:
		board_ready.emit()
	level_changed.emit()
	power_id = ""
	hiding_power.emit()
	drag_start = Vector2i(-1, -1)

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
	if (coords.x < 0 || coords.x >= get_size().x || coords.y < 0 || coords.y >= get_size().y):
		return SquareStates.INVALID
	return master [active_id][SQUARE_MAP_KEY][coords.x][coords.y]

func get_board_ready() -> bool:
	if active_id == "default":
		return false
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

func get_level_parameters() -> Dictionary:
	if LevelLibrary.level_exists(active_id):
		return LevelLibrary.get_level_parameters(active_id)
	else:
		return {}

func get_guideline_interval() -> Vector2i:
	var SIZE = master [active_id][SIZE_KEY]
	var result = Vector2i(0, 0)
	result.x = roundi(SIZE.x / floor(sqrt(SIZE.x)))
	result.y = roundi(SIZE.y / floor(sqrt(SIZE.y)))
	return result

func change_square_state(new_state: SquareStates):
	if get_chosen_coords_state() == new_state:
		return
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

func set_square_state(coords: Vector2i, new_state: SquareStates):
	if master [active_id].has(LOCKS_KEY):
		if master [active_id][LOCKS_KEY].has(coords):
			return
	push_stack({
		'coords': coords,
		'old_state': get_position_state(coords),
		'new_state': new_state
	})
	master [active_id][SQUARE_MAP_KEY][coords.x][coords.y] = new_state
	square_changed.emit(coords)
	generate_line_comparisons(coords)
	check_hints()

func solve_square(coords: Vector2i):
	var new_square_state = master [active_id][TARGET_MAP_KEY][coords.x][coords.y]
	if new_square_state == SquareStates.EMPTY:
		new_square_state = SquareStates.FLAGGED
	master [active_id][SQUARE_MAP_KEY][coords.x][coords.y] = new_square_state
	square_changed.emit(coords)
	generate_line_comparisons(coords)

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

func get_complete_levels() -> Array:
	var complete_levels = []
	for level in master.keys():
		if master [level].has(VICTORY_KEY) and master [level][VICTORY_KEY]:
			complete_levels.append(level)
	return complete_levels

func prepare_square_map(parameters: Dictionary):
	if master [active_id].has(SQUARE_MAP_KEY):
		return
	elif parameters.has('square_map'):
		set_square_map(parameters['square_map'])
	else:
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

func reset():
	if master.has(active_id):
		generate_empty_map()
		clear_stack()
		clear_locks()
		var level_data = LevelLibrary.get_level(active_id)
		if level_data.has("parameters"):
			var parameters = level_data["parameters"]
			if parameters.has("locks"):
				for coords in parameters["locks"]:
					lock_square(coords)
			if parameters.has("powers"):
				set_powers(parameters["powers"])
		board_ready.emit()
		clear_stack()
		if master [active_id].has(VICTORY_KEY):
			master [active_id][VICTORY_KEY] = false
			victory_changed.emit(false)
		drag_start = Vector2i(-1, -1)
		drag_min = -1
		drag_max = -1

func clear_notes():
	if master.has(active_id):
		for i in master [active_id][SQUARE_MAP_KEY].keys():
			for index in range(master [active_id][SQUARE_MAP_KEY][i].size()):
				if master [active_id][SQUARE_MAP_KEY][i][index] == SquareStates.NOTE_MARKED:
					master [active_id][SQUARE_MAP_KEY][i][index] = SquareStates.EMPTY
				elif master [active_id][SQUARE_MAP_KEY][i][index] == SquareStates.NOTE_FLAGGED:
					master [active_id][SQUARE_MAP_KEY][i][index] = SquareStates.EMPTY
		board_ready.emit()

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
	if Input.is_action_just_released("Flag") and (toggle_state == ToggleStates.FLAGGING or toggle_state == ToggleStates.EMPTYING_FLAGGED):
		reset_toggle_state()
		drag_direction = Axis.NONE
		drag_start = Vector2i(-1, -1)
		drag_ended.emit()
		drag_min = -1
		drag_max = -1
	elif Input.is_action_just_released("Mark") and (toggle_state == ToggleStates.MARKING or toggle_state == ToggleStates.EMPTYING_MARKED):
		reset_toggle_state()
		drag_direction = Axis.NONE
		drag_start = Vector2i(-1, -1)
		drag_ended.emit()
		drag_min = -1
		drag_max = -1

func handle_input_press():
	var state = get_chosen_coords_state()
	if toggle_state == ToggleStates.NOTHING:
		if Input.is_action_just_pressed("Flag"):
			handle_flag_press(state)
			drag_start = chosen_coords
			drag_begun.emit()
		elif Input.is_action_just_pressed("Mark"):
			if power_id != "":
				use_power()
			else:
				handle_mark_press(state)
				drag_start = chosen_coords
				drag_begun.emit()
	if Input.is_action_just_pressed("Undo"):
		undo()
	elif Input.is_action_just_pressed("Redo"):
		redo()
	if Input.is_action_just_pressed("Up"):
		arrow_move(Vector2i(chosen_coords.x, chosen_coords.y - 1))
	elif Input.is_action_just_pressed("Down"):
		arrow_move(Vector2i(chosen_coords.x, chosen_coords.y + 1))
	elif Input.is_action_just_pressed("Left"):
		arrow_move(Vector2i(chosen_coords.x - 1, chosen_coords.y))
	elif Input.is_action_just_pressed("Right"):
		arrow_move(Vector2i(chosen_coords.x + 1, chosen_coords.y))
	handle_drag_motion()
	handle_toggle_state()

func handle_drag_motion():
	if drag_start != Vector2i(-1, -1) && drag_start != chosen_coords:
		if drag_direction == Axis.NONE:
			var delta_x = abs(chosen_coords.x - drag_start.x)
			var delta_y = abs(chosen_coords.y - drag_start.y)
			if delta_x > delta_y:
				drag_direction = Axis.X
				drag_min = drag_start.x
				drag_max = drag_start.x
			else:
				drag_direction = Axis.Y
				drag_min = drag_start.y
				drag_max = drag_start.y
		if drag_direction == Axis.X:
			set_chosen_coords(Vector2i(chosen_coords.x, drag_start.y))
			update_drag_length(chosen_coords.x)
		elif drag_direction == Axis.Y:
			set_chosen_coords(Vector2i(drag_start.x, chosen_coords.y))
			update_drag_length(chosen_coords.y)

func update_drag_length(index: int):
	if index < drag_min:
		drag_min = index
		drag_length_changed.emit(drag_max - drag_min + 1)
	elif index > drag_max:
		drag_max = index
		drag_length_changed.emit(drag_max - drag_min + 1)

func arrow_move(direction: Vector2i):
	if direction.x < 0 || direction.x >= get_size().x || direction.y < 0 || direction.y >= get_size().y:
		return
	set_chosen_coords(direction)

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
	var features = get_level_parameters().get('features', {})
	if features.has('notes') and !features['notes']:
		return
	if Input.is_action_just_pressed("Note"):
		set_notes(true)
	elif Input.is_action_just_released("Note"):
		set_notes(false)
	if Input.is_action_just_pressed("Cancel"):
		cancel_power()
#endregion Input Handling

#region Target Map Generation
func generate_target_map(parameters: Dictionary):
	if (parameters.has('generation')):
		if not parameters['generation'].has('method'):
			printerr("Target map generation method not specified")
			return
		var method = parameters['generation']['method']
		match method:
			"sine":
				generate_sine_map(parameters)
			"ellipse":
				generate_ellipse_map(parameters)
			"random":
				random_center_diamond_map(parameters)
			"waveform":
				generate_waveform_map(parameters)
			"handcrafted":
				build_handcrafted_map(parameters)
			_:
				printerr("Unknown target map generation method: ", method)
	else:
		random_center_diamond_map(parameters)
	if parameters.has('override'):
		var override = parameters['override']
		if override.has('marked'):
			for coords in override['marked']:
				set_target_position(coords, SquareStates.MARKED)
		if override.has('empty'):
			for coords in override['empty']:
				set_target_position(coords, SquareStates.EMPTY)
	generate_headers()

func random_center_diamond_map(parameters: Dictionary):
	master [active_id][TARGET_MAP_KEY] = {}
	var SIZE = get_size()
	for i in SIZE.x:
		master [active_id][TARGET_MAP_KEY][i] = create_empty_array(SIZE.y)
		for k in SIZE.y:
			var average = roundi((SIZE.x + SIZE.y) / 2.0)
			var random_value = randf_range(-2.5, 2.5)
			if (parameters.has('randomness')):
				random_value *= parameters['randomness']
			var sum = absi(i - roundi(average / 2.0)) + absi(k - roundi(average / 2.0))
			sum += random_value
			var marked = sum < roundi(average / 1.95)
			if (marked):
				set_target_position(Vector2i(i, k), SquareStates.MARKED)
			else:
				set_target_position(Vector2i(i, k), SquareStates.EMPTY)

func generate_sine_map(parameters: Dictionary):
	master [active_id][TARGET_MAP_KEY] = {}
	var SIZE = get_size()
	for i in SIZE.x:
		master [active_id][TARGET_MAP_KEY][i] = create_empty_array(SIZE.y)
		for k in SIZE.y:
			var frequency = parameters['generation']['frequency']
			var x = i * frequency.x
			var y = k * frequency.y
			if parameters['generation'].has('offset'):
				var offset = parameters['generation']['offset']
				x += offset.x
				y += offset.y
			var sine_value = sin(x) + sin(y)
			if (parameters.has('randomness')):
				var r = parameters['randomness']
				sine_value += randf_range(-r, r)
			if parameters['generation'].has('constant'):
				sine_value += parameters['generation']['constant']
			if (sine_value > 0):
				set_target_position(Vector2i(i, k), SquareStates.MARKED)
			else:
				set_target_position(Vector2i(i, k), SquareStates.EMPTY)
	
func generate_ellipse_map(parameters: Dictionary):
	master [active_id][TARGET_MAP_KEY] = {}
	var SIZE = get_size()
	for i in SIZE.x:
		master [active_id][TARGET_MAP_KEY][i] = create_empty_array(SIZE.y)
		for k in SIZE.y:
			var s = float(i + .5) / float(SIZE.x)
			var t = float(k + .5) / float(SIZE.y)
			var x = pow(s * 2.0 - 1, 2)
			var y = pow(t * 2.0 - 1, 2)
			if (parameters.has('generation')):
				var scale = parameters['generation']['scale']
				x *= scale.x
				y *= scale.y
			var sum = x + y
			if (parameters.has('randomness')):
				var r = parameters['randomness']
				sum += randf_range(-r, r)
			if (sum < 1):
				set_target_position(Vector2i(i, k), SquareStates.MARKED)
			else:
				set_target_position(Vector2i(i, k), SquareStates.EMPTY)

func generate_waveform_map(parameters: Dictionary):
	master [active_id][TARGET_MAP_KEY] = {}
	var SIZE = get_size()
	for i in SIZE.x:
		master [active_id][TARGET_MAP_KEY][i] = create_empty_array(SIZE.y)
		for k in SIZE.y:
			var sum = 0.0
			for series in parameters['generation']['series']:
				var series_sum = 0.0
				for term in series:
					if series_sum == 0.0:
						series_sum = handle_series(term, i, k)
					else:
						series_sum *= handle_series(term, i, k)
				sum += series_sum
			if (parameters.has('randomness')):
				var r = parameters['randomness']
				sum += randf_range(-r, r)
			if parameters['generation'].has('constant'):
				sum += parameters['generation']['constant']
			if (sum > 0):
				set_target_position(Vector2i(i, k), SquareStates.MARKED)
			else:
				set_target_position(Vector2i(i, k), SquareStates.EMPTY)

func handle_series(term: Dictionary, i: int, k: int) -> float:
	var frequency = term['frequency'] if term.has('frequency') else Vector2(1, 1)
	var x = float(i) * float(frequency.x)
	var y = float(k) * float(frequency.y)
	if term.has('offset'):
		var offset = term['offset']
		x += offset.x
		y += offset.y
	var term_sum = 0.0
	if term.has('nested'):
		term_sum = sin(handle_series(term['nested'], i, k)) # + sin(x) + sin(y)?
	else:
		term_sum = sin(x) + sin(y)
	if term.has('amplitude'):
		term_sum *= term['amplitude']
	return term_sum

func build_handcrafted_map(parameters: Dictionary):
	master [active_id][TARGET_MAP_KEY] = {}
	var gen = parameters['generation']
	var marking = gen['marked']
	var SIZE = parameters['size']
	if !gen.has('marked'):
		push_error("Handcrafted map generation parameters not specified")
	if marking.keys().size() != SIZE.y:
		push_error("Handcrafted map vertical does not match target map size: ",
		marking.keys().size(), " != ", SIZE.y)
	for i in range(SIZE.x):
		master [active_id][TARGET_MAP_KEY][i] = create_empty_array(SIZE.y)
	for y in marking.keys():
		if marking[y].size() != SIZE.x:
			push_error("Handcrafted map horizontal does not match target map size: ",
			marking[y].size(), " != ", SIZE.x)
		var row = marking[y]
		for x in range(row.size()):
			if row[x] == 1:
				set_target_position(Vector2i(x, y), SquareStates.MARKED)
			else:
				set_target_position(Vector2i(x, y), SquareStates.EMPTY)

func create_empty_array(length: int) -> Array:
	var array = []
	for i in length:
		array.append(SquareStates.EMPTY)
	return array
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

#region Header Generation
func generate_headers():
	master [active_id][HEADERS_KEY] = {}
	var map = master [active_id][TARGET_MAP_KEY]
	var SIZE = get_size()
	
	generate_header_for_axis('X', SIZE.x, SIZE.y, map)
	generate_header_for_axis('Y', SIZE.y, SIZE.x, map)

func generate_header_for_axis(axis: String, primary_size: int, secondary_size: int, map: Dictionary):
	master [active_id][HEADERS_KEY][axis] = {}
	for i in primary_size:
		var line = []
		for k in secondary_size:
			if axis == 'X':
				if map.has(i):
					line.append(map[i][k])
			else:
				if map.has(k):
					line.append(map[k][i])
		master [active_id][HEADERS_KEY][axis][i] = generate_sequence_for_array(line)

func generate_sequence_for_array(line: Array) -> Array:
	var sequence = []
	var total = 0
	var count = 0
	var segment = []
	for i in line.size():
		var is_marked = line[i] == SquareStates.MARKED
		if is_marked:
			count += 1
			total += 1
			segment.append(i)
		elif count > 0:
			sequence.append({'length': str(count), 'segment': segment})
			count = 0
			segment = []
	if count > 0 || total == 0:
		sequence.append({'length': str(count), 'segment': segment})
	return sequence

func generate_complicated_sequence_for_array(line: Array, complications: Array) -> Array:
	var sequence = []
	var total = 0
	var count = 0
	var segment = []
	for i in line.size():
		var is_different = line[i] == SquareStates.MARKED
		for complication in complications:
			if complication["type"] == "delta":
				var variable_axis = 'X' if complication.has('variable_column') else 'Y'
				var x = complication['variable_column'] if variable_axis == 'X' else i
				var y = i if variable_axis == 'X' else complication['variable_row']
				var value = master [active_id][SQUARE_MAP_KEY][x][y]
				var value_eval = value == SquareStates.MARKED
				if value_eval == is_different:
					is_different = false
				else:
					is_different = true
				
		if is_different:
			count += 1
			total += 1
			segment.append(i)
		elif count > 0:
			sequence.append({'length': str(count), 'segment': segment})
			count = 0
			segment = []
	if count > 0 || total == 0:
		sequence.append({'length': str(count), 'segment': segment})
	return sequence
#endregion Header Generation

#region Danger Square Detection
func cleanup_danger_segments():
	var x_offset_segments = find_offset_by_one_segments('X')
	var y_offset_segments = find_offset_by_one_segments('Y')
	var danger_segments = find_shared_end_segments(x_offset_segments, y_offset_segments)
	var changed_points = resolve_danger_square(danger_segments)
	update_headers_for_points(changed_points)

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
		var is_marked = map.has(row) and map[row][k] == SquareStates.MARKED

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
		var is_marked = map.has(i) and map[i][column] == SquareStates.MARKED

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

#region Header Aid
func generate_all_line_comparisons():
	var x_comparisons = {}
	for x in range(get_size().x):
		x_comparisons[x] = compare_line_to_header('X', x)
	var y_comparisons = {}
	for y in range(get_size().y):
		y_comparisons[y] = compare_line_to_header('Y', y)
	lines_compared.emit({
		"X": x_comparisons,
		"Y": y_comparisons
	})
	return {
		"X": x_comparisons,
		"Y": y_comparisons
	}

func generate_line_comparisons(coords: Vector2i):
	var x_comparisons = {coords.x: compare_line_to_header('X', coords.x)}
	var y_comparisons = {coords.y: compare_line_to_header('Y', coords.y)}
	var complications = get_complications_by_variable(coords)
	for complication in complications:
		var subject_axis = 'X' if complication.has('subject_column') else 'Y'
		var subject_index = complication['subject_column'] if subject_axis == 'X' else complication['subject_row']
		if subject_axis == 'X':
			x_comparisons[subject_index] = compare_line_to_header('X', subject_index)
		else:
			y_comparisons[subject_index] = compare_line_to_header('Y', subject_index)
	lines_compared.emit({
		"X": x_comparisons,
		"Y": y_comparisons
	})

func compare_line_to_header(axis: String, line_index: int = -1) -> Array:
	var map = master [active_id][SQUARE_MAP_KEY]
	var headers = get_header(axis)
	var SIZE = get_size()
	var secondary_size = SIZE.y if axis == 'X' else SIZE.x

	var line = []
	for k in range(secondary_size):
		if axis == 'X':
			line.append(map[line_index][k])
		else:
			line.append(map[k][line_index])
	var complications = get_complications(axis, line_index)
	var generated_segments = []
	if complications.size() == 0:
		generated_segments = generate_sequence_for_array(line)
	else:
		generated_segments = generate_complicated_sequence_for_array(line, complications)
	var header_segments = headers[line_index]
	var comparison = []
	for h in header_segments:
		var found = false
		for j in range(generated_segments.size()):
			if h['length'] == generated_segments[j]['length']:
				generated_segments.remove_at(j)
				found = true
				break
		if found:
			comparison.append(true)
		else:
			comparison.append(false)
	return comparison

func get_complications_by_variable(coords: Vector2i) -> Array:
	var complications = []
	if master [active_id].has(COMPLICATIONS_KEY):
		for complication in master [active_id][COMPLICATIONS_KEY]:
			if complication.has('variable_column') and complication['variable_column'] == coords.x:
				complications.append(complication)
			elif complication.has('variable_row') and complication['variable_row'] == coords.y:
				complications.append(complication)
	return complications

#endregion Header Aid

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
		set_victory_true()
	else:
		error_lines_updated.emit(find_error_lines())

func find_error_lines():
	return {
		'X': find_error_lines_for_axis('X'),
		'Y': find_error_lines_for_axis('Y')
	}

func find_error_lines_for_axis(axis: String) -> Array:
	var errors = []
	var map = master [active_id][SQUARE_MAP_KEY]
	var SIZE = get_size()
	var primary_size
	var secondary_size
	if axis == 'X':
		primary_size = SIZE.x
		secondary_size = SIZE.y
	else:
		primary_size = SIZE.y
		secondary_size = SIZE.x
	for i in primary_size:
		var line = []
		for k in secondary_size:
			if axis == 'X':
				line.append(map[i][k])
			else:
				line.append(map[k][i])
		var sequence = generate_sequence_for_array(line)
		var target_sequence = master [active_id][HEADERS_KEY][axis][i]
		for j in range(target_sequence.size()):
			if j >= sequence.size():
				errors.append(i)
				break
			if target_sequence[j]['length'] != sequence[j]['length']:
				errors.append(i)
				break
			
	return errors
	
#region Victory Handling
func set_victory_true():
	master [active_id][VICTORY_KEY] = true
	victory_changed.emit(true)

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
	var level = LevelLibrary.get_next_level(active_id)
	if level == "":
		return
	set_active_id(level)

func prev_level():
	var level = LevelLibrary.get_prev_level(active_id)
	if level == "":
		return
	set_active_id(level)

func has_next_level():
	return LevelLibrary.has_next_level(active_id)

func has_prev_level():
	return LevelLibrary.has_prev_level(active_id)
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
	if ! master [active_id].has(COMPLICATIONS_KEY):
		master [active_id][COMPLICATIONS_KEY] = []
	master [active_id][COMPLICATIONS_KEY].append(complication)
	generate_delta_header(complication)
	generate_delta_footer(complication)

func generate_delta_header(complication: Dictionary):
	var subject_axis = 'X' if complication.has('subject_column') else 'Y'
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
		complication_variable = str('c', complication['variable_column'] + 1)
	elif (complication.has('variable_row')):
		complication_variable = str('r', complication['variable_row'] + 1)
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

func get_complications(axis: String, index: int) -> Array:
	if ! master.has(active_id):
		push_error("Attempted to get complications with invalid id: ", active_id)
		return []
	if ! master [active_id].has(COMPLICATIONS_KEY):
		return []
	var result_list = []
	for complication in master [active_id][COMPLICATIONS_KEY]:
		var complication_axis = 'X' if complication.has('subject_column') else 'Y'
		if complication_axis != axis:
			continue
		var subject_index = complication['subject_column'] if complication_axis == 'X' else complication['subject_row']
		if subject_index != index:
			continue
		result_list.append(complication)
	return result_list
#endregion Complications

#region Stack Functions
func get_stack() -> Array:
	if ! master.has(active_id):
		return []
	if ! master [active_id].has(STACK_KEY):
		return []
	return master [active_id][STACK_KEY]

func set_stack(stack: Array):
	if ! master.has(active_id):
		push_error("Attempted to set the stack with invalid id: ", active_id)
		return
	if ! master [active_id].has(STACK_KEY):
		master [active_id][STACK_KEY] = []
	master [active_id][STACK_INDEX_KEY] = stack.size() - 1
	master [active_id][STACK_KEY] = stack
	stack_changed.emit()

func push_stack(action: Dictionary):
	if ! master.has(active_id):
		push_error("Attempted to push to the stack with invalid id: ", active_id)
		return
	if ! master [active_id].has(STACK_KEY):
		master [active_id][STACK_KEY] = []
	if ! master [active_id].has(STACK_INDEX_KEY):
		master [active_id][STACK_INDEX_KEY] = get_stack_size() - 1
	master [active_id][STACK_KEY] = master [active_id][STACK_KEY].slice(0, master [active_id][STACK_INDEX_KEY])
	master [active_id][STACK_INDEX_KEY] += 1
	master [active_id][STACK_KEY].append(action)
	stack_changed.emit()

func pop_stack() -> Dictionary:
	if ! master.has(active_id):
		push_error("Attempted to pop from the stack with invalid id: ", active_id)
		return {}
	if ! master [active_id].has(STACK_KEY):
		return {}
	if master [active_id][STACK_KEY].size() == 0:
		return {}
	if master [active_id][STACK_INDEX_KEY] == master [active_id][STACK_KEY].size() - 1:
		master [active_id][STACK_INDEX_KEY] = master [active_id][STACK_KEY].size() - 1
	var pop = master [active_id][STACK_KEY].pop_back()
	stack_changed.emit()
	return pop

func undo_stack() -> Dictionary:
	if ! master.has(active_id):
		push_error("Attempted to undo from the stack with invalid id: ", active_id)
		return {}
	if ! master [active_id].has(STACK_KEY):
		return {}
	if master [active_id][STACK_KEY].size() == 0:
		return {}
	if master [active_id][STACK_INDEX_KEY] == 0:
		return {}
	master [active_id][STACK_INDEX_KEY] -= 1
	var index = master [active_id][STACK_INDEX_KEY]
	stack_changed.emit()
	return master [active_id][STACK_KEY][index]

func redo_stack() -> Dictionary:
	if ! master.has(active_id):
		push_error("Attempted to redo from the stack with invalid id: ", active_id)
		return {}
	if ! master [active_id].has(STACK_KEY):
		return {}
	if master [active_id][STACK_KEY].size() == 0:
		return {}
	if master [active_id][STACK_INDEX_KEY] >= master [active_id][STACK_KEY].size():
		return {}
	var index = master [active_id][STACK_INDEX_KEY]
	master [active_id][STACK_INDEX_KEY] += 1
	stack_changed.emit()
	return master [active_id][STACK_KEY][index]

func get_stack_index() -> int:
	if ! master.has(active_id):
		push_error("Attempted to get the stack index with invalid id: ", active_id)
		return -1
	if ! master [active_id].has(STACK_INDEX_KEY):
		return -1
	return master [active_id][STACK_INDEX_KEY]

func clear_stack():
	if ! master.has(active_id):
		push_error("Attempted to clear the stack with invalid id: ", active_id)
		return
	if ! master [active_id].has(STACK_KEY):
		return
	master [active_id][STACK_INDEX_KEY] = -1
	master [active_id][STACK_KEY] = []
	stack_changed.emit()

func get_stack_size() -> int:
	if ! master.has(active_id):
		push_error("Attempted to get the stack size with invalid id: ", active_id)
		return 0
	if ! master [active_id].has(STACK_KEY):
		return 0
	return master [active_id][STACK_KEY].size()

func undo():
	var action = undo_stack()
	if action == {}:
		return
	var coords = action['coords']
	var old_state = action['old_state']
	master [active_id][SQUARE_MAP_KEY][coords.x][coords.y] = old_state
	square_changed.emit(coords)
	generate_line_comparisons(coords)

func redo():
	var action = redo_stack()
	if action == {}:
		return
	var coords = action['coords']
	var new_state = action['new_state']
	master [active_id][SQUARE_MAP_KEY][coords.x][coords.y] = new_state
	square_changed.emit(coords)
	generate_line_comparisons(coords)

#endregion Stack Functions

#region locking
func lock_square(coords: Vector2i):
	if ! master.has(active_id):
		push_error("Attempted to lock square with invalid id: ", active_id)
		return
	if ! master [active_id].has(LOCKS_KEY):
		master [active_id][LOCKS_KEY] = []
	if ! master [active_id][LOCKS_KEY].has(coords):
		solve_square(coords)
		master [active_id][LOCKS_KEY].append(coords)
		lock_added_to_square.emit(coords)
	
func get_locks() -> Array:
	if ! master.has(active_id):
		push_error("Attempted to get locks with invalid id: ", active_id)
		return []
	if ! master [active_id].has(LOCKS_KEY):
		return []
	return master [active_id][LOCKS_KEY]

func clear_locks():
	if ! master.has(active_id):
		push_error("Attempted to clear locks with invalid id: ", active_id)
		return
	if ! master [active_id].has(LOCKS_KEY):
		return
	master [active_id][LOCKS_KEY] = []
	locks_cleared.emit()
#endregion locking

#region etching
func find_etching_number(coords: Vector2i) -> int:
	var value = 0
	var x = coords.x
	var y = coords.y
	value += 1 if get_position_state(Vector2i(x - 1, y - 1)) == SquareStates.MARKED else 0
	value += 1 if get_position_state(Vector2i(x - 1, y)) == SquareStates.MARKED else 0
	value += 1 if get_position_state(Vector2i(x - 1, y + 1)) == SquareStates.MARKED else 0
	value += 1 if get_position_state(Vector2i(x, y - 1)) == SquareStates.MARKED else 0
	value += 1 if get_position_state(Vector2i(x, y)) == SquareStates.MARKED else 0
	value += 1 if get_position_state(Vector2i(x, y + 1)) == SquareStates.MARKED else 0
	value += 1 if get_position_state(Vector2i(x + 1, y - 1)) == SquareStates.MARKED else 0
	value += 1 if get_position_state(Vector2i(x + 1, y)) == SquareStates.MARKED else 0
	value += 1 if get_position_state(Vector2i(x + 1, y + 1)) == SquareStates.MARKED else 0
	return value

#endregion etching

#region powers
func start_power(id: String):
	if !power_id == id:
		power_id = id
		showing_power.emit(id)
	else:
		cancel_power()

func use_power():
	if power_id == "":
		return
	if power_id == "power_lock":
		if get_charges(power_id) > 0:
			power_lock()
			use_charge(power_id)
	power_id = ""
	hiding_power.emit()

func power_lock():
	lock_square(chosen_coords)

func get_powers():
	if active_id == "default":
		return []
	if ! master.has(active_id):
		push_error("Attempted to get powers with invalid id: ", active_id)
		return []
	if ! master [active_id].has(POWERS_KEY):
		return []
	return master [active_id][POWERS_KEY]

func set_powers(powers: Dictionary):
	if ! master.has(active_id):
		push_error("Attempted to set powers with invalid id: ", active_id)
		return
	if ! master [active_id].has(POWERS_KEY):
		master [active_id][POWERS_KEY] = []
	master [active_id][POWERS_KEY] = powers.duplicate()
	powers_changed.emit()

func load_powers():
	if ! master.has(active_id):
		push_error("Attempted to load powers with invalid id: ", active_id)
		return
	if ! master [active_id].has(POWERS_KEY):
		return
	var powers = master [active_id][POWERS_KEY]
	for power in powers:
		if power.has('type'):
			match power['type']:
				"power_lock":
					start_power(power['id'])
				_:
					print("Unknown power type: ", power['type'])

func get_charges(id: String) -> int:
	if ! master.has(active_id):
		push_error("Attempted to get charges with invalid id: ", active_id)
		return 0
	if ! master [active_id].has(POWERS_KEY):
		return 0
	var powers = master [active_id][POWERS_KEY]
	if powers.has(id):
		if powers[id].has('charges'):
			return powers[id]['charges']
	return 0

func use_charge(id: String):
	if ! master.has(active_id):
		push_error("Attempted to use charge with invalid id: ", active_id)
		return
	if ! master [active_id].has(POWERS_KEY):
		return
	var powers = master [active_id][POWERS_KEY]
	if powers.has(id):
		if powers[id].has('charges'):
			powers[id]['charges'] -= 1
			power_charge_used.emit(id)

func cancel_power():
	if power_id == "":
		return
	power_id = ""
	hiding_power.emit()
#endregion powers

#region Hint
func set_hints(list: Array):
	master [active_id][HINTS_KEY] = list

func has_hints() -> bool:
	return master [active_id].has(HINTS_KEY) and master [active_id][HINTS_KEY].size() > 0

func get_hints() -> Array:
	if ! master.has(active_id):
		push_error("Attempted to get hints with invalid id: ", active_id)
		return []
	if ! master [active_id].has(HINTS_KEY):
		return []
	return master [active_id][HINTS_KEY]

func get_next_hint() -> Array:
	var hints = get_hints()
	for hint in hints:
		var complete = true
		for square in hint:
			if get_position_state(square) != get_target_position(square):
				complete = false
		if !complete:
			return hint
	return []

func request_hint():
	hint_display = get_next_hint()
	hint_display_changed.emit()

func check_hints():
	var complete = true
	for hint in hint_display:
		if get_position_state(hint) != get_target_position(hint):
			complete = false
	if complete:
		hint_display = []
		hint_display_changed.emit()

#endregion Hint
