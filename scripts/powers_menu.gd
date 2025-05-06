extends ScrollContainer

@export var power_button_container: VBoxContainer
var generic_button_scene := preload("res://scenes/generic_selection_button.tscn")
var powers = {}

func _ready() -> void:
	State.powers_changed.connect(load_powers)
	State.level_changed.connect(load_powers)
	State.power_charge_used.connect(update_power_charge)
	load_powers()

func load_powers():
	for child in power_button_container.get_children():
		child.queue_free()

	for power_id in State.get_powers():
		var power_row = HBoxContainer.new()
		var power_instance = generic_button_scene.instantiate()
		var power_locale = PowersLibary.data[power_id]
		power_instance.text = power_locale["power_name"]
		power_instance.set_value(power_id)
		power_instance.thing_selected.connect(State.start_power)
		power_button_container.add_child(power_row)
		power_row.add_child(power_instance)
		var power_charge_label = Label.new()
		power_charge_label.text = str(State.get_charges(power_id))
		power_row.add_child(power_charge_label)
		powers[power_id] = {
			"button": power_instance,
			"label": power_charge_label
		}
		power_instance.set_global_tooltip_text(power_locale["power_description"])

func update_power_charge(power_id: String) -> void:
	var new_charges = State.get_charges(power_id)
	if power_id in powers:
		powers[power_id]["label"].text = str(new_charges)
		if new_charges == 0:
			powers[power_id]["button"].set_disabled(true)
		else:
			powers[power_id]["button"].set_disabled(false)
