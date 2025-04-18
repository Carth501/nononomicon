extends ScrollContainer

@export var power_button_container: VBoxContainer
var generic_button_scene := preload("res://scenes/generic_selection_button.tscn")

func _ready() -> void:
	State.powers_changed.connect(load_powers)
	State.level_changed.connect(load_powers)
	load_powers()

func load_powers():
	for child in power_button_container.get_children():
		child.queue_free()

	for power in State.get_powers():
		var power_instance = generic_button_scene.instantiate()
		var power_locale = PowersLibary.data[power]
		power_instance.text = power_locale["power_name"]
		power_instance.set_value(power)
		power_instance.thing_selected.connect(State.start_power)
		power_button_container.add_child(power_instance)
