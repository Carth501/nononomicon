class_name NonogramBoard extends Control

@export var scroll_container: ScrollContainer
@export var nonogram_squares: NonogramSquares
@export var header_row: XHeaderRow
@export var header_col: YHeaderCol
@export var victory_label: Label
var scrolling := false
var id: int

func _ready() -> void:
	State.board_ready.connect(prepare_board)
	prepare_board()
	State.victory.connect(display_victory)

func set_board_id(board_id: int):
	id = board_id

func prepare_board():
	if (State.master.has(State.SQUARE_MAP_KEY)):
		nonogram_squares.create_square_displays()
		header_row.generate_cells(State.master [State.HEADERS_KEY]['X'])
		header_col.generate_cells(State.master [State.HEADERS_KEY]['Y'])
	
func cheat():
	State.cheat_reveal_all_squares()

func _process(_delta: float) -> void:
	var percent_x = get_percent_x()
	var percent_y = get_percent_y()
	set_header_scroll(Vector2(percent_x, percent_y))

func set_header_scroll(vector: Vector2):
	header_row.set_percent_x(vector.x)
	header_col.set_percent_y(vector.y)

func get_percent_x() -> float:
	var max_x = scroll_container.get_h_scroll_bar().max_value
	return float(scroll_container.scroll_horizontal) / max_x

func get_percent_y() -> float:
	var max_y = scroll_container.get_v_scroll_bar().max_value
	return float(scroll_container.scroll_vertical) / max_y

func _on_submit_pressed() -> void:
	State.submit()

func display_victory():
	victory_label.visible = true

func _on_notes_switch_toggled(toggled_on: bool) -> void:
	State.set_notes_no_signal(toggled_on)

func _on_save_button_pressed() -> void:
	SaveManager.save("ManualSave")
