class_name NonogramSquare extends Control

@export var coords: Vector2i
@export var note_label: Label
@export var highlighter: ColorRect
@export var color_square: ColorRect
@export var lock_tex: TextureRect

func setup(new_coords: Vector2i):
	coords = new_coords
	State.square_changed.connect(compare_coords)
	set_focus_mode(FOCUS_ALL)

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
	# https://coolors.co/105e6e-321e1e-4e3636-cd1818-ece2d0
	# v2 https://coolors.co/f1e9d2-382012-03180c-6d2817-0c0c0c
	if (square_state == State.SquareStates.EMPTY):
		note_label.visible = false
		color_square.set_color(Color('F1E9D2'))
	elif (square_state == State.SquareStates.MARKED):
		note_label.visible = false
		color_square.set_color(Color('6D2817'))
	elif (square_state == State.SquareStates.FLAGGED):
		note_label.visible = false
		color_square.set_color(Color('0C0C0C'))
	elif (square_state == State.SquareStates.NOTE_MARKED):
		note_label.visible = true
		color_square.set_color(Color('F1E9D2'))
		note_label.set("theme_override_colors/font_color", Color('6D2817'))
	elif (square_state == State.SquareStates.NOTE_FLAGGED):
		note_label.visible = true
		color_square.set_color(Color('F1E9D2'))
		note_label.set("theme_override_colors/font_color", Color('0C0C0C'))

func set_highlighter(value: bool):
	highlighter.visible = value
	if value:
		take_focus()

func take_focus():
	grab_focus()

func lock_square(value: bool):
	if value:
		lock_tex.show()
	else:
		lock_tex.hide()
