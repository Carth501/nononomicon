class_name NonogramBoard extends Control

@export var nonogram_scroll_container: ScrollContainer
@export var nonogram_squares: NonogramSquares
@export var header_row: XHeaderRow
@export var header_col: YHeaderCol
@export var footer_row: XFooterRow
@export var footer_col: YFooterCol
@export var victory_label: Label
@export var margin_container: MarginContainer
var scrolling := false
var highlighting: Vector2i

func _ready():
	prepare_board()
	State.board_ready.connect(prepare_board)
	State.victory.connect(display_victory)
	State.coords_changed.connect(update_highlighter_square)
	State.error_lines_updated.connect(error_lines)

func prepare_board():
	if (State.get_board_ready()):
		nonogram_squares.create_square_displays()
		header_row.generate_cells(State.get_header('X'))
		header_col.generate_cells(State.get_header('Y'))
		footer_row.generate_cells(State.get_footer('X'), State.get_size().x)
		footer_col.generate_cells(State.get_footer('Y'), State.get_size().y)
		var id = State.get_active_id()
		if (State.master [id].has(State.VICTORY_KEY) and State.master [id][State.VICTORY_KEY]):
			display_victory()
		else:
			hide_victory()

func _process(_delta: float) -> void:
	var percent_x = get_percent_x()
	var percent_y = get_percent_y()
	set_header_scroll(Vector2(percent_x, percent_y))

func set_header_scroll(vector: Vector2):
	header_row.set_percent(vector)
	header_col.set_percent(vector)
	footer_row.set_percent(vector)
	footer_col.set_percent(vector)

func get_percent_x() -> float:
	var max_x = nonogram_scroll_container.get_h_scroll_bar().max_value
	return float(nonogram_scroll_container.scroll_horizontal) / max_x

func get_percent_y() -> float:
	var max_y = nonogram_scroll_container.get_v_scroll_bar().max_value
	return float(nonogram_scroll_container.scroll_vertical) / max_y

func display_victory():
	victory_label.visible = true

func hide_victory():
	victory_label.visible = false

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
