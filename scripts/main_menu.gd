extends Control

func new_game():
	get_tree().change_scene_to_file("res://scenes/nonogram_board.tscn")

func exit():
	get_tree().quit()
