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

var chosen_coords: Vector2i
var master: Dictionary
var SIZE:= Vector2i(9,9)
var SQUARE_MAP_KEY:= 'square_map'
var TARGET_MAP_KEY:= 'target_map'
var HEADERS_KEY:= 'headers'

func _ready() -> void:
	generate_empty_map(SIZE)
	generate_target_map(SIZE)
	print(master[TARGET_MAP_KEY])

func set_chosen_coords(new_coords: Vector2i):
	chosen_coords = new_coords

func get_position_state(coords: Vector2i) -> SquareStates:
	return master[SQUARE_MAP_KEY][coords.x][coords.y]

func change_square_state(new_state: SquareStates):
	if(chosen_coords == Vector2i(-1, -1)):
		return
	if(master[SQUARE_MAP_KEY][chosen_coords.x][chosen_coords.y] == new_state):
		master[SQUARE_MAP_KEY][chosen_coords.x][chosen_coords.y] = SquareStates.EMPTY
	else:
		master[SQUARE_MAP_KEY][chosen_coords.x][chosen_coords.y] = new_state
	square_changed.emit(chosen_coords)

func generate_empty_map(size: Vector2i):
	if(size.x <= 0 || size.y <= 0):
		printerr("Invalid map size: ", size)
	master[SQUARE_MAP_KEY]={}
	for i in size.x:
		var column: Array[SquareStates] = []
		for k in size.y:
			column.append(SquareStates.EMPTY)
		master[SQUARE_MAP_KEY][i] = column
	board_ready.emit()

func _process(_delta):
	if Input.is_action_just_pressed("Mark"):
		change_square_state(SquareStates.MARKED)
	elif Input.is_action_just_pressed("Flag"):
		change_square_state(SquareStates.FLAGGED)

func generate_target_map(size: Vector2i):
	random_center_map(size)

func random_center_map(size: Vector2i):
	master[TARGET_MAP_KEY]={}
	for i in size.x:
		master[TARGET_MAP_KEY][i] = {}
		for k in size.y:
			var average = roundi((size.x + size.y) / 2)
			var random_value = randi_range(-2,2)
			var sum = absi(i - roundi(average/2)) + absi(k - roundi(average/2))
			sum += random_value
			var marked = sum < roundi(average/2)
			if(marked):
				master[TARGET_MAP_KEY][i][k] = SquareStates.MARKED
