class_name Generic_Selection_Button extends Button

signal thing_selected(thing: String)
@export var thing: String
@export var global_tooltip_text: String
@export var tooltips_enabled: bool = false

func _ready():
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func set_global_tooltip_text(new_text: String):
	global_tooltip_text = new_text
	tooltips_enabled = true

func set_tooltips(setting: bool):
	tooltips_enabled = setting

func set_value(new_thing: String):
	thing = new_thing

func _on_button_pressed():
	thing_selected.emit(thing)

func _on_mouse_entered():
	if tooltips_enabled:
		GlobalTooltip.show_tooltip(global_tooltip_text)

func _on_mouse_exited():
	if tooltips_enabled:
		GlobalTooltip.hide_tooltip()