class_name OptionsMenu extends PanelContainer

@export var master_volume_slider: Slider
@export var music_volume_slider: Slider
@export var fullscreen_checkbox: CheckBox

func _ready():
	MusicPlayer.music_volume_changed.connect(initial_volume)
	DisplayHandler.fullscreen_changed.connect(initial_fullscreen)
	initial_volume()
	initial_fullscreen()

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
