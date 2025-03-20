extends Control

@export var nonogram_squares: NonogramSquares
@export var header_row: XHeaderRow
@export var header_col: YHeaderCol
@export var input_state_label: Label

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
