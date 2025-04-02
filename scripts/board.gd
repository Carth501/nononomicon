class_name NonogramBoard extends Control

@export var scroll_container: ScrollContainer
@export var nonogram_squares: NonogramSquares
@export var header_row: XHeaderRow
@export var header_col: YHeaderCol
@export var footer_row: XFooterRow
@export var footer_col: YFooterCol
@export var victory_label: Label
var scrolling := false
var highlighting: NonogramSquare

func _ready() -> void:
	State.board_ready.connect(prepare_board)
	prepare_board()
	State.victory.connect(display_victory)
	State.coords_changed.connect(update_highlighter_square)

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
	header_row.set_percent_x(vector.x)
	header_col.set_percent_y(vector.y)
	footer_row.set_percent_x(vector.x)
	footer_col.set_percent_y(vector.y)

func get_percent_x() -> float:
	var max_x = scroll_container.get_h_scroll_bar().max_value
	return float(scroll_container.scroll_horizontal) / max_x

func get_percent_y() -> float:
	var max_y = scroll_container.get_v_scroll_bar().max_value
	return float(scroll_container.scroll_vertical) / max_y

func display_victory():
	victory_label.visible = true

func hide_victory():
	victory_label.visible = false

func update_highlighter_square(coords: Vector2i):
	if highlighting != null:
		highlighting.set_highlighter(false)
	if (coords.x == -1 or coords.y == -1):
		return
	highlighting = nonogram_squares.get_square(coords)
	highlighting.set_highlighter(true)
