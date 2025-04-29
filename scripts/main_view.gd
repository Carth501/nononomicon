extends CenterContainer

@export var board: NonogramBoard

func _on_resized() -> void:
	fit_child_in_rect(board, get_rect())