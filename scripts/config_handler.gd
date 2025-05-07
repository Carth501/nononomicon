extends Node

var config: ConfigFile

func _ready() -> void:
	config = ConfigFile.new()
	var err = config.load("user://settings.cfg")
	if err != OK:
		return

func update_setting(key: String, value: Variant) -> void:
	config.set_value("Settings", key, value)
	config.save("user://settings.cfg")

func get_setting(key: String) -> Variant:
	return config.get_value("Settings", key, null)
