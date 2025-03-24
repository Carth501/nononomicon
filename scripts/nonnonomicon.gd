class_name Nononomicon extends Control

var nonogram_board := preload("res://scenes/nonogram_board.tscn")
var pages := []
@export var book: Control

func _ready():
	var page: NonogramBoard = nonogram_board.instantiate()
	book.add_child(page)
	pages.append(page)
