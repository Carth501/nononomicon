extends Control

@export var scroll_container: ScrollContainer
@export var nonogram_squares: NonogramSquares
@export var header_row: XHeaderRow
@export var header_col: YHeaderCol
@export var input_state_label: Label
var scrolling := false

func _ready() -> void:
	State.board_ready.connect(prepare_board)
	prepare_board()
	State.toggle_state_changed.connect(update_input_state_label)

func prepare_board():
	if (State.master.has(State.SQUARE_MAP_KEY)):
		nonogram_squares.create_square_displays()
		header_row.generate_cells(State.master [State.HEADERS_KEY]['X'])
		header_col.generate_cells(State.master [State.HEADERS_KEY]['Y'])
	
func cheat():
	State.cheat_reveal_all_squares()

func update_input_state_label(new_state: State.ToggleStates):
	match new_state:
		State.ToggleStates.NOTHING:
			input_state_label.text = "Nothing"
		State.ToggleStates.MARKING:
			input_state_label.text = "Marking"
		State.ToggleStates.EMPTYING_MARKED:
			input_state_label.text = "Emptying Marked"
		State.ToggleStates.FLAGGING:
			input_state_label.text = "Flagging"
		State.ToggleStates.EMPTYING_FLAGGED:
			input_state_label.text = "Emptying Flagged"


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