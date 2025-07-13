extends Node

signal fullscreen_changed(fullscreen: bool)
signal ui_scale_changed(ui_scale: float)

var fullscreen := false
var ui_scale := 2.0

func _ready() -> void:
	await ConfigHandler.ready
	# I am concerned that this might prevent this function from running.
	# If this function runs before the config handler is ready, does it wait forever?
	fullscreen = ConfigHandler.get_setting("fullscreen")
	if fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	fullscreen_changed.emit(fullscreen)
	ui_scale = ConfigHandler.get_setting("ui_scale", 2.0)
	ui_scale_changed.emit(ui_scale)

func set_fullscreen(value: bool) -> void:
	if value:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	ConfigHandler.update_setting("fullscreen", value)

func set_ui_scale(value: float) -> void:
	if value < 0.75:
		value = 0.75
	elif value > 2.0:
		value = 2.0
	ui_scale = value
	ConfigHandler.update_setting("ui_scale", value)
	ui_scale_changed.emit(ui_scale)