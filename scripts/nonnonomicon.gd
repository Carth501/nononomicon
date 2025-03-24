class_name Nononomicon extends Control

var nonogram_board := preload("res://scenes/nonogram_board.tscn")
var index := preload("res://scenes/index.tscn")
var pages := {}
@export var book: Control

func _ready():
	open_page("index")

func open_page(id: String):
	if (!pages.has(id)):
		var page: NonogramBoard = nonogram_board.instantiate()
		page.set_board_id(id)
		pages[id] = page
		page.prepare_board()
		book.add_child(page)
	close_all_except(id)

func close_all_except(id: String):
	for page in pages.values():
		if (page.id == id):
			page.show()
		else:
			page.hide()