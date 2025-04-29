class_name NonogramSquare extends Control

@export var coords: Vector2i
@export var note_label: Label
@export var highlighter: ColorRect
@export var color_square: ColorRect
var bleed_away_scene = preload("res://scenes/burnaway.tscn")
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
		change_color(Color('F1E9D2'))
	elif (square_state == State.SquareStates.MARKED):
		note_label.visible = false
		change_color(Color('6D2817'), Color('880808'))
	elif (square_state == State.SquareStates.FLAGGED):
		note_label.visible = false
		change_color(Color('0C0C0C'))
	elif (square_state == State.SquareStates.NOTE_MARKED):
		note_label.visible = true
		change_color(Color('F1E9D2'))
		note_label.set("theme_override_colors/font_color", Color('6D2817'))
	elif (square_state == State.SquareStates.NOTE_FLAGGED):
		note_label.visible = true
		change_color(Color('F1E9D2'))
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

func change_color(new_color: Color, edge_color: Color = Color(0, 0, 0, 0)):
	var bleed_away := bleed_away_scene.instantiate()
	add_child(bleed_away)
	move_child(bleed_away, -1)
	var old_color = color_square.color
	if edge_color == Color(0, 0, 0, 0):
		edge_color = new_color.lerp(old_color, 0.5)
	
	bleed_away.start_bleeding(get_point() / size, old_color, edge_color)
	color_square.set_color(new_color)

func get_point() -> Vector2:
	var mouse_relative: Vector2 = get_global_mouse_position() - get_global_position()
	var pos_clamped = mouse_relative.clamp(Vector2(0, 0), Vector2(size.x, size.y))
	if pos_clamped == mouse_relative:
		return pos_clamped
	else:
		var x = randf_range(0, size.x)
		var y = randf_range(0, size.y)
		return Vector2(x, y)
