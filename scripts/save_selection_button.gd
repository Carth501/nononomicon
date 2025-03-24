class_name Save_Selection_Button extends Button

signal save_selected(save_name: String)
var save_name: String

func set_value(new_name: String):
	save_name = new_name
	text = save_name

func _on_button_pressed():
	save_selected.emit(save_name)