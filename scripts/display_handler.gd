extends Node

signal fullscreen_changed(fullscreen: bool)

var fullscreen := false

func _ready() -> void:
	await ConfigHandler.ready
	fullscreen = ConfigHandler.get_setting("fullscreen")
	if fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	fullscreen_changed.emit(fullscreen)

func set_fullscreen(value: bool) -> void:
	if value:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	ConfigHandler.update_setting("fullscreen", value)
