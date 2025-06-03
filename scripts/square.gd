class_name NonogramSquare extends Control

@export var coords: Vector2i
@export var note_label: Label
@export var highlighter: ColorRect
@export var hint_square: ColorRect
@export var color_square: ColorRect
var bleed_away_scene = preload("res://scenes/burnaway.tscn")
@export var lock_tex: TextureRect
@export var effect_list: Control
@export var etching_label: Label

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
		note_label.set("theme_override_colors/font_color", Color('a82d0f'))
	elif (square_state == State.SquareStates.NOTE_FLAGGED):
		note_label.visible = true
		change_color(Color('F1E9D2'))
		note_label.set("theme_override_colors/font_color", Color('0C0C0C'))

func set_highlighter(value: bool):
	highlighter.visible = value
	if value:
		take_focus()

func set_hint_square(value: bool):
	hint_square.visible = value

func take_focus():
	grab_focus()

func lock_square(value: bool):
	if value:
		lock_tex.show()
	else:
		lock_tex.hide()

func change_color(new_color: Color, edge_color: Color = Color(0, 0, 0, 0)):
	var bleed_away := bleed_away_scene.instantiate()
	effect_list.add_child(bleed_away)
	effect_list.move_child(bleed_away, 0)
	var old_color = color_square.color
	if edge_color == Color(0, 0, 0, 0):
		edge_color = new_color.lerp(old_color, 0.5)
	
	bleed_away.start_bleeding(get_point() / size, old_color, edge_color)
	await get_tree().process_frame
	color_square.set_color.call_deferred(new_color)

func get_point() -> Vector2:
	var mouse_relative: Vector2 = get_global_mouse_position() - get_global_position()
	var pos_clamped = mouse_relative.clamp(Vector2(0, 0), Vector2(size.x, size.y))
	if pos_clamped == mouse_relative:
		return pos_clamped
	else:
		var x = randf_range(0, size.x)
		var y = randf_range(0, size.y)
		return Vector2(x, y)

func add_etching(value: int):
	etching_label.text = str(value)
	etching_label.show()

func clear_etching():
	etching_label.text = ""
	etching_label.hide()

func set_overlay_item_opacity(opacity: float):
	highlighter.modulate.a = opacity
	hint_square.modulate.a = opacity
	note_label.modulate.a = opacity
	lock_tex.modulate.a = opacity
	etching_label.modulate.a = opacity