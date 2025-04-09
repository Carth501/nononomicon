extends CenterContainer

@export var board: NonogramBoard

func _on_resized() -> void:
	print("rect", get_rect())
	fit_child_in_rect(board, get_rect())