extends Control

@export var save_management_panel: SaveLoadControl

func new_game():
	get_tree().change_scene_to_file("res://scenes/nononomicon.tscn")

func exit():
	get_tree().quit()

func load_game():
	save_management_panel.show()
	save_management_panel.set_mode(SaveLoadControl.ManagerMode.LOAD)
