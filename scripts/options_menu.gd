class_name OptionsMenu extends PanelContainer

@export var master_volume_slider: Slider
@export var music_volume_slider: Slider
@export var fullscreen_checkbox: CheckBox
@export var ui_scale: Slider
@export var ui_scale_value_label: Label

func _ready():
	MusicPlayer.music_volume_changed.connect(initial_volume)
	DisplayHandler.fullscreen_changed.connect(initial_fullscreen)
	DisplayHandler.ui_scale_changed.connect(initial_scale)
	initial_volume()
	initial_fullscreen()
	initial_scale(DisplayHandler.ui_scale)

func initial_volume():
	master_volume_slider.set_value_no_signal(MusicPlayer.master_volume * 100.0)
	music_volume_slider.set_value_no_signal(MusicPlayer.music_volume * 100.0)

func set_master_volume(value: float):
	MusicPlayer.set_master_volume(value)

func set_music_volume(value: float):
	MusicPlayer.set_music_volume(value)

func _on_exit_button_pressed() -> void:
	hide()

func set_fullscreen(value: bool) -> void:
	DisplayHandler.set_fullscreen(value)

func initial_fullscreen() -> void:
	fullscreen_checkbox.set_pressed_no_signal(DisplayHandler.fullscreen)

func initial_scale(value: float) -> void:
	ui_scale.set_value_no_signal(value)
	ui_scale_value_label.set_text("%.2f" % value)

func set_ui_scale(value: float) -> void:
	DisplayHandler.set_ui_scale(value)
	ui_scale_value_label.set_text("%.2f" % value)


func _on_ui_scale_slider_drag_ended(value_changed: bool) -> void:
	if !value_changed:
		return
	set_ui_scale(ui_scale.get_value())
