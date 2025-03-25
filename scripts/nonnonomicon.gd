class_name Nononomicon extends Control

var nonogram_board := preload("res://scenes/nonogram_board.tscn")
var index := preload("res://scenes/index.tscn")
var pages := {}
@export var book: Control
@export var game_ui: Control

func _ready():
	open_page("index")

func open_page(id: String):
	print('open_page ', id)
	if (id == "index"):
		game_ui.hide()
		if (!pages.has(id)):
			var page: Index = index.instantiate()
			pages[id] = page
			book.add_child(page)
			page.level_selected.connect(open_page)
	elif (!pages.has(id)):
		State.set_active_id(id)
		var page: NonogramBoard = nonogram_board.instantiate()
		page.set_board_id(id)
		pages[id] = page
		page.prepare_board()
		book.add_child(page)
		game_ui.show()
	close_all_except(id)

func close_all_except(id: String):
	for page_id in pages.keys():
		if (page_id == id):
			pages[page_id].show()
		else:
			pages[page_id].hide()
