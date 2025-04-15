extends Label

@export var highlight_square: ColorRect
@export var error_square: ColorRect

func set_highlighter(value: bool):
	highlight_square.visible = value

func set_error(value: bool):
	error_square.visible = value