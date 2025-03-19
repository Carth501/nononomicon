extends Control

@export var nonogram_squares: NonogramSquares
@export var header_row: XHeaderRow
@export var header_col: YHeaderCol

func _ready() -> void:
	State.board_ready.connect(prepare_board)
	prepare_board()

func prepare_board():
	if (State.master.has(State.SQUARE_MAP_KEY)):
		nonogram_squares.create_square_displays()
		header_row.generate_cells(State.master [State.HEADERS_KEY]['X'])
		header_col.generate_cells(State.master [State.HEADERS_KEY]['Y'])
	
func cheat():
	State.cheat_reveal_all_squares()