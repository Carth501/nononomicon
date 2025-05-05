extends Control

@export var save_management_panel: SaveLoadInterface
@export var continue_button: Button
@export var options_menu: OptionsMenu

func _ready() -> void:
	if SaveManager.get_save_file_list().size() == 0:
		continue_button.disabled = true
	else:
		continue_button.disabled = false

func new_game():
	State.new_game()
	get_tree().change_scene_to_file("res://scenes/nononomicon.tscn")

func exit():
	get_tree().quit()

func load_game():
	save_management_panel.show()
	save_management_panel.set_mode(SaveLoadInterface.ManagerMode.LOAD)

func _on_continue_button_pressed() -> void:
	SaveManager.load_latest_save()
	get_tree().change_scene_to_file("res://scenes/nononomicon.tscn")


func _on_options_pressed() -> void:
	options_menu.show()
