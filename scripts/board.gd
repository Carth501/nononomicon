class_name NonogramBoard extends Container

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
var highlighting: Vector2i
var scrolling: bool = false

func _ready():
	prepare_board()
	State.board_ready.connect(prepare_board)
	State.victory_changed.connect(toggle_victory)
	State.coords_changed.connect(update_highlighter_square)
	State.error_lines_updated.connect(error_lines)
	State.lines_compared.connect(update_header_assist)
	State.lock_added_to_square.connect(lock_square)
	State.locks_cleared.connect(clear_locks)
	victory_label.visible = false

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
		State.generate_all_line_comparisons()
		guidelines.create_lines(State.get_guideline_interval())
		check_locks()

func toggle_victory(value: bool):
	victory_label.visible = value

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
	var col_head_width = maxf(header_col.get_size().x, 90)
	var row_head_height = maxf(header_row.get_size().y, 90)
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
	var x_margin = (size.x - col_head_width - nonogram_scroll_container.size.x - 90) / 2
	var y_margin = (size.y - row_head_height - nonogram_scroll_container.size.y - 90) / 2
	board_margin_control.position = Vector2(x_margin, y_margin)
	board_margin_control.size = Vector2(size.x - x_margin, size.y - y_margin)
	nonogram_scroll_container.position = Vector2(col_head_width, row_head_height)
	header_row_scroll.position = Vector2(col_head_width, 0)
	header_col_scroll.position = Vector2(0, row_head_height)
	footer_row_scroll.position = Vector2(col_head_width, row_head_height + nonogram_scroll_container.size.y)
	footer_col_scroll.position = Vector2(col_head_width + nonogram_scroll_container.size.x, row_head_height)
	guidelines_mask.size = nonogram_scroll_container.size
	guidelines_mask.global_position = nonogram_scroll_container.global_position

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
