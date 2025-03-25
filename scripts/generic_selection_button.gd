class_name Generic_Selection_Button extends Button

signal thing_selected(thing: String)
@export var thing: String

func set_value(new_thing: String):
	thing = new_thing
	text = thing

func _on_button_pressed():
	thing_selected.emit(thing)