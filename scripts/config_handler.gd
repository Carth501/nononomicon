extends Node

var config: ConfigFile

func _ready() -> void:
	config = ConfigFile.new()
	var err = config.load("user://settings.cfg")
	if err != OK:
		push_error("Failed to load settings.cfg: %s" % err)

func update_setting(key: String, value: Variant) -> void:
	config.set_value("Settings", key, value)
	config.save("user://settings.cfg")

func get_setting(key: String, default: Variant = -1) -> Variant:
	return config.get_value("Settings", key, default)
