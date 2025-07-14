extends Control

@export var save_management_panel: SaveLoadInterface
@export var continue_button: Button
@export var options_menu: OptionsMenu
@export var version_label: Label
@export var credits_panel: PanelContainer

func _ready() -> void:
	version_label.text = "v" + str(ProjectSettings.get_setting("application/config/version"))
	if SaveManager.get_save_file_list().size() == 0:
		continue_button.disabled = true
	else:
		continue_button.disabled = false
	DisplayHandler.ui_scale_changed.connect(adjust_ui_scale)
	adjust_ui_scale(DisplayHandler.ui_scale)

func new_game():
	State.new_game()
	enter_nononomicon()

func exit():
	get_tree().quit()

func load_game():
	save_management_panel.show()
	save_management_panel.set_mode(SaveLoadInterface.ManagerMode.LOAD)

func _on_continue_button_pressed() -> void:
	SaveManager.load_latest_save()
	enter_nononomicon()

func _on_options_pressed() -> void:
	options_menu.show()

func toggle_credits_panel():
	if credits_panel.visible:
		credits_panel.hide()
	else:
		credits_panel.show()

func enter_nononomicon():
	if get_mobile_mode():
		get_tree().change_scene_to_file("res://scenes/mobile_nononomicon.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/nononomicon.tscn")

func get_mobile_mode() -> bool:
	return ProjectSettings.get_setting("application/config/is_mobile")

func adjust_ui_scale(value: float) -> void:
	var window_size = DisplayServer.window_get_size()
	scale = Vector2(value, value)
	size = window_size / value
