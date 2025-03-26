class_name Nononomicon extends Control

var nonogram_board := preload("res://scenes/nonogram_board.tscn")
var index := preload("res://scenes/index.tscn")
var pages := {}
@export var book: Control
@export var game_ui: Control
@export var next_button: Button
@export var prev_button: Button

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
	else:
		if (!pages.has(id)):
			State.set_active_id(id)
			var page: NonogramBoard = nonogram_board.instantiate()
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

func cheat():
	State.cheat_reveal_all_squares()

func _on_submit_pressed() -> void:
	State.submit()

func _on_notes_switch_toggled(toggled_on: bool) -> void:
	State.set_notes_no_signal(toggled_on)

func _on_save_button_pressed() -> void:
	SaveManager.save("ManualSave")

func _on_next_button_pressed() -> void:
	State.next_level()

func _on_index_button_pressed() -> void:
	open_page("index")

func _on_prev_button_pressed() -> void:
	State.prev_level()
