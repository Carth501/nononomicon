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

func NOTIFICATION_SORT_CHILDREN() -> void:
	var col_head_width = maxf(header_col.get_size().x, 90)
	var row_head_height = maxf(header_row.get_size().y, 90)
	header_row_scroll.size.y = row_head_height
	header_col_scroll.size.x = col_head_width
	var nonogram_scroll_size = size - Vector2(col_head_width + 90, row_head_height + 90)
	nonogram_scroll_container.size.x = clamp(nonogram_scroll_size.x, 0, nonogram_squares.size.x + 6)
	nonogram_scroll_container.size.y = clamp(nonogram_scroll_size.y, 0, nonogram_squares.size.y + 6)
	header_row_scroll.size.x = nonogram_scroll_container.size.x
	header_col_scroll.size.y = nonogram_scroll_container.size.y
	footer_row_scroll.size = Vector2(nonogram_scroll_container.size.x, 90)
	footer_col_scroll.size = Vector2(90, nonogram_scroll_container.size.y)
	var x_margin = (size.x - col_head_width - nonogram_scroll_container.size.x - 90) / 2
	var y_margin = (size.y - row_head_height - nonogram_scroll_container.size.y - 90) / 2
	nonogram_scroll_container.position = Vector2(x_margin + col_head_width, y_margin + row_head_height)
	header_row_scroll.position = Vector2(x_margin + col_head_width, y_margin)
	header_col_scroll.position = Vector2(x_margin + 0, y_margin + row_head_height)
	footer_row_scroll.position = Vector2(x_margin + col_head_width, y_margin + row_head_height + nonogram_scroll_container.size.y)
	footer_col_scroll.position = Vector2(x_margin + col_head_width + nonogram_scroll_container.size.x, y_margin + row_head_height)
