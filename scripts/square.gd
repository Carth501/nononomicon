class_name NonogramSquare extends ColorRect

@export var coords: Vector2i
@export var note_label: Label
@export var highlighter: ColorRect

func setup(new_coords: Vector2i):
	coords = new_coords
	State.square_changed.connect(compare_coords)

func _on_mouse_entered() -> void:
	State.set_chosen_coords(coords)

func _on_mouse_exited() -> void:
	State.set_chosen_coords(Vector2i(-1, -1))

func get_square_state():
	State.get_position_state(coords)

func compare_coords(updated_square_coords: Vector2i):
	if (updated_square_coords == coords):
		set_square_appearance(State.get_position_state(coords))

func set_square_appearance(square_state: State.SquareStates):
	# https://coolors.co/105e6e-321e1e-4e3636-cd1818-ece2d0-c49949
	if (square_state == State.SquareStates.EMPTY):
		note_label.visible = false
		set_color(Color('ECE2D0'))
	elif (square_state == State.SquareStates.MARKED):
		note_label.visible = false
		set_color(Color('105E6E'))
	elif (square_state == State.SquareStates.FLAGGED):
		note_label.visible = false
		set_color(Color('CD1818'))
	elif (square_state == State.SquareStates.NOTE_MARKED):
		note_label.visible = true
		set_color(Color('ECE2D0'))
		note_label.set("theme_override_colors/font_color", Color('105E6E'))
	elif (square_state == State.SquareStates.NOTE_FLAGGED):
		note_label.visible = true
		set_color(Color('ECE2D0'))
		note_label.set("theme_override_colors/font_color", Color('CD1818'))

func set_highlighter(value: bool):
	highlighter.visible = value
