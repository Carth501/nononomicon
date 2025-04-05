class_name NonogramBoard extends Control

@export var nonogram_scroll_container: ScrollContainer
@export var nonogram_squares: NonogramSquares
@export var header_row: XHeaderRow
@export var header_col: YHeaderCol
@export var footer_row: XFooterRow
@export var footer_col: YFooterCol
var scrolling := false
var highlighting: Vector2i

func _ready():
	prepare_board()
	State.board_ready.connect(prepare_board)
	# State.victory.connect(display_victory)
	State.coords_changed.connect(update_highlighter_square)
	State.error_lines_updated.connect(error_lines)

func prepare_board():
	if (State.get_board_ready()):
		nonogram_squares.create_square_displays()
		header_row.generate_cells(State.get_header('X'))
		header_col.generate_cells(State.get_header('Y'))
		footer_row.generate_cells(State.get_footer('X'), State.get_size().x)
		footer_col.generate_cells(State.get_footer('Y'), State.get_size().y)
		# var id = State.get_active_id()
		# if (State.master [id].has(State.VICTORY_KEY) and State.master [id][State.VICTORY_KEY]):
		# 	display_victory()
		# else:
		# 	hide_victory()

# func display_victory():
# 	victory_label.visible = true

# func hide_victory():
# 	victory_label.visible = false

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
