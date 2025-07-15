class_name NonogramBoard extends Container

signal menu_toggled

@export var nonogram_scroll_container: ScrollContainer
@export var nonogram_squares: NonogramSquares
@export var header_row: XHeaderRow
@export var header_col: YHeaderCol
@export var footer_row: XFooterRow
@export var footer_col: YFooterCol
@export var header_row_scroll: ScrollContainer
@export var header_col_scroll: ScrollContainer
@export var footer_row_scroll: ScrollContainer
@export var footer_col_scroll: ScrollContainer
@export var board_margin_control: Control
@export var SCROLLBAR_MARGIN: int = 8
@export var victory_label: Label
@export var guidelines: Guidelines
@export var guidelines_mask: Control
@export var coords_display: Label
@export var board_size_display: Label
@export var percent_marked_label: Label
@export var submission_error_display: SubmissionErrorDisplay
@export var timer_display: Label
@export var victory_splash: VictorySplashController
@export var something_wrong: PanelContainer
@export var virtual_controls: VirtualControls
@export var toggle_menu_button: Button
var highlighting: Vector2i
var scrolling: bool = false

var col_head_width := 0.0
var row_head_height := 0.0
var x_margin := 0.0
var y_margin := 0.0

func _ready():
	prepare_board()
	State.board_ready.connect(prepare_board)
	State.victory_changed.connect(toggle_victory)
	State.coords_changed.connect(update_highlighter_square)
	State.error_lines_updated.connect(error_lines)
	State.lines_compared.connect(update_header_assist)
	State.lock_added_to_square.connect(lock_square)
	State.locks_cleared.connect(clear_locks)
	State.coords_changed.connect(update_coords_display)
	State.level_changed.connect(update_board_size)
	State.hint_display_changed.connect(set_hint_squares)
	State.square_changed.connect(calculate_percent_marked_with_coords)
	State.level_changed.connect(calculate_percent_marked)
	State.level_changed.connect(set_timer_display)
	State.level_changed.connect(toggle_percent_marked_label)
	State.level_changed.connect(toggle_submission_error_display)
	State.timer_changed.connect(update_time_display)
	State.etching_added_to_square.connect(add_etching)
	victory_label.visible = false
	State.level_changed.connect(change_level_handle_victory_fade)
	State.something_wrong.connect(toggle_something_wrong_message)

func prepare_board():
	if (State.get_board_ready()):
		header_row.generate_cells(State.get_header('X'))
		header_col.generate_cells(State.get_header('Y'))
		footer_row.generate_cells(State.get_footer('X'), State.get_size().x)
		footer_col.generate_cells(State.get_footer('Y'), State.get_size().y)
		nonogram_squares.create_square_displays()
		var id = State.get_active_id()
		if State.master [id].has(State.VICTORY_KEY):
			toggle_victory(State.master [id][State.VICTORY_KEY])
		else:
			toggle_victory(false)
		sort_children()
		var assist_level = State.get_assist_level()
		if assist_level != State.HeaderAssistLevel.NO_ASSIST:
			State.generate_all_line_comparisons()
		guidelines.create_lines(State.get_guideline_interval())
		check_locks()
		set_timer_display()
		apply_etchings()
		victory_splash.check_victory_fade()

func toggle_victory(value: bool):
	# victory_label.visible = value
	if value:
		victory_splash.start_splash()
	else:
		victory_splash.reset_splash()

func update_highlighter_square(coords: Vector2i):
	if highlighting != Vector2i(-1, -1):
		nonogram_squares.get_square(highlighting).set_highlighter(false)
		header_row.get_cell(highlighting.x).set_highlighter(false)
		header_col.get_cell(highlighting.y).set_highlighter(false)
		footer_row.get_cell(highlighting.x).set_highlighter(false)
		footer_col.get_cell(highlighting.y).set_highlighter(false)
	highlighting = coords
	if (coords.x == -1 or coords.y == -1):
		return
	nonogram_squares.get_square(highlighting).set_highlighter(true)
	header_row.get_cell(highlighting.x).set_highlighter(true)
	header_col.get_cell(highlighting.y).set_highlighter(true)
	footer_row.get_cell(highlighting.x).set_highlighter(true)
	footer_col.get_cell(highlighting.y).set_highlighter(true)

func error_lines(errors: Dictionary):
	if (errors.has("X")):
		header_row.set_error_lines(errors["X"])
		footer_row.set_error_lines(errors["X"])
	if (errors.has("Y")):
		header_col.set_error_lines(errors["Y"])
		footer_col.set_error_lines(errors["Y"])

func _process(_delta):
	var h_bar = nonogram_scroll_container.get_h_scroll_bar()
	header_row_scroll.get_h_scroll_bar().value = h_bar.value
	footer_row_scroll.get_h_scroll_bar().value = h_bar.value
	var v_bar = nonogram_scroll_container.get_v_scroll_bar()
	header_col_scroll.get_v_scroll_bar().value = v_bar.value
	footer_col_scroll.get_v_scroll_bar().value = v_bar.value
	guidelines.global_position = nonogram_squares.global_position

func sort_children() -> void:
	await get_tree().process_frame
	col_head_width = maxf(header_col.get_size().x, 90)
	row_head_height = maxf(header_row.get_size().y, 90)
	header_row_scroll.size.y = row_head_height
	header_col_scroll.size.x = col_head_width
	var nonogram_scroll_size = size - Vector2(col_head_width + 90, row_head_height + 90)
	var squares_size = State.get_size() * 64
	nonogram_scroll_container.size.x = clamp(nonogram_scroll_size.x, 0, squares_size.x + SCROLLBAR_MARGIN)
	nonogram_scroll_container.size.y = clamp(nonogram_scroll_size.y, 0, squares_size.y + SCROLLBAR_MARGIN)
	header_row_scroll.size.x = nonogram_scroll_container.size.x
	header_col_scroll.size.y = nonogram_scroll_container.size.y
	footer_row_scroll.size = Vector2(nonogram_scroll_container.size.x, 90)
	footer_col_scroll.size = Vector2(90, nonogram_scroll_container.size.y)
	x_margin = (size.x - col_head_width - nonogram_scroll_container.size.x - 90) / 2
	y_margin = (size.y - row_head_height - nonogram_scroll_container.size.y - 90) / 2
	board_margin_control.position = Vector2(x_margin, y_margin)
	board_margin_control.size = Vector2(size.x - x_margin, size.y - y_margin)
	nonogram_scroll_container.position = Vector2(col_head_width, row_head_height)
	header_row_scroll.position = Vector2(col_head_width, 0)
	header_col_scroll.position = Vector2(0, row_head_height)
	footer_row_scroll.position = Vector2(col_head_width, row_head_height + nonogram_scroll_container.size.y)
	footer_col_scroll.position = Vector2(col_head_width + nonogram_scroll_container.size.x, row_head_height)
	guidelines_mask.size = nonogram_scroll_container.size
	guidelines_mask.global_position = nonogram_scroll_container.global_position
	var left_edge_position = x_margin + col_head_width
	var top_edge_position = y_margin + row_head_height

	var top_left_corner_position = Vector2(
		left_edge_position - 8,
		top_edge_position - 8
		) * DisplayHandler.ui_scale
	var top_right_corner_position = Vector2(
		left_edge_position + header_row_scroll.size.x + 8,
		top_edge_position - 8
		) * DisplayHandler.ui_scale
	var bottom_left_corner_position = Vector2(
		left_edge_position - 8,
		top_edge_position + header_col_scroll.size.y + 8
		) * DisplayHandler.ui_scale
	var bottom_right_corner_position = Vector2(
		left_edge_position + header_row_scroll.size.x + 8,
		top_edge_position + header_col_scroll.size.y + 8
		) * DisplayHandler.ui_scale

	board_size_display.global_position = top_left_corner_position - board_size_display.size
	coords_display.global_position = top_right_corner_position + Vector2(0, -coords_display.size.y)

	timer_display.global_position = bottom_left_corner_position
	virtual_controls.global_position = bottom_right_corner_position
	virtual_controls.size = Vector2(
		min(x_margin, 256), min(y_margin, 128))
	percent_marked_label.global_position = bottom_right_corner_position

	submission_error_display.global_position = Vector2(
		left_edge_position - 8,
		top_edge_position + header_col_scroll.size.y + 8
		) * DisplayHandler.ui_scale
	something_wrong.global_position = Vector2(
		size.x / 2 - something_wrong.size.x / 2,
		size.y / 2 - something_wrong.size.y / 2
		) * DisplayHandler.ui_scale
	toggle_menu_button.global_position = Vector2(size.x - toggle_menu_button.size.x - 8, 0)

func update_header_assist(comparisons: Dictionary):
	header_row.set_assist(comparisons["X"])
	header_col.set_assist(comparisons["Y"])

func check_locks():
	var locks = State.get_locks()
	for lock in locks:
		nonogram_squares.get_square(lock).lock_square(true)

func lock_square(coords: Vector2i):
	nonogram_squares.get_square(coords).lock_square(true)

func clear_locks():
	for i in State.get_size().x:
		for j in State.get_size().y:
			nonogram_squares.get_square(Vector2i(i, j)).lock_square(false)

func update_coords_display(new_coords: Vector2i):
	if (new_coords == Vector2i(-1, -1)):
		coords_display.text = ""
	else:
		coords_display.text = str(new_coords.x + 1) + ", " + str(new_coords.y + 1)

func update_board_size():
	var board_size = State.get_size()
	board_size_display.text = str(board_size.x) + " x " + str(board_size.y)

func set_hint_squares():
	nonogram_squares.clear_hint_squares()
	for square in State.hint_display:
		nonogram_squares.get_square(square).set_hint_square(true)

func clear_hint_squares():
	nonogram_squares.clear_hint_squares()

func toggle_percent_marked_label():
	var params = State.get_level_parameters()
	var features = params.features
	var timer = features.timer
	var percent_marked = features.percent_marked
	if percent_marked && !timer:
		percent_marked_label.show()
	else:
		percent_marked_label.hide()


func calculate_percent_marked_with_coords(_coords: Vector2i):
	calculate_percent_marked()

func calculate_percent_marked():
	var percent_marked = floori(State.get_percent_marked() * 100.0)
	percent_marked_label.text = str(percent_marked) + "%"
	if percent_marked == 100:
		percent_marked_label.add_theme_color_override("font_color", Color('#82ed72'))
	else:
		percent_marked_label.remove_theme_color_override("font_color")

func toggle_submission_error_display():
	var features = State.get_level_features()
	var submission_errors = features.submission_errors
	if submission_errors > 0:
		submission_error_display.show()
		submission_error_display.create_list(submission_errors)
	else:
		submission_error_display.hide()

func set_submission_error_count():
	var errors = State.get_submission_errors()
	submission_error_display.set_error_count(errors)

func set_timer_display():
	var features = State.get_level_features()
	var timer = features.timer
	if timer:
		timer_display.show()
		update_time_display(State.get_time())
	else:
		timer_display.hide()

func update_time_display(time: float):
	var rounded_time = floori(time)
	var minutes = floori(rounded_time / 60.0)
	var seconds = floori(rounded_time % 60)
	timer_display.text = str(minutes) + ":" + str(seconds).pad_zeros(2)
	timer_display.global_position = Vector2(
		x_margin + col_head_width - timer_display.size.x - 8,
		y_margin + row_head_height + header_col_scroll.size.y + 8
		)

func add_etching(coords: Vector2i):
	var square = nonogram_squares.get_square(coords)
	if square:
		var etching_string = State.get_etching_string(coords)
		square.add_etching(etching_string)
	else:
		push_error("Tried to add etching to a square that doesn't exist: " + str(coords))

func clear_etching(coords: Vector2i):
	var square = nonogram_squares.get_square(coords)
	if square:
		square.clear_etching()
	else:
		push_error("Tried to clear etching from a square that doesn't exist: " + str(coords))

func clear_all_ettings():
	for i in State.get_size().x:
		for j in State.get_size().y:
			clear_etching(Vector2i(i, j))

func apply_etchings():
	var etchings = State.get_etchings()
	for etching in etchings:
		var square = nonogram_squares.get_square(etching.coords)
		square.add_etching(str(etching.etching_number))

func change_victory_fade(setting: bool):
	victory_splash.toggle_victory_fade(setting)

func change_level_handle_victory_fade():
	victory_splash.check_victory_fade()

func toggle_something_wrong_message(wrong: bool):
	something_wrong.visible = wrong

func toggle_menu():
	menu_toggled.emit()
