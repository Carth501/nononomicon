class_name OptionsMenu extends PanelContainer

@export var master_volume_slider: Slider
@export var music_volume_slider: Slider
var config: ConfigFile

func _ready():
	MusicPlayer.music_volume_changed.connect(initial_volume)
	initial_volume()

func initial_volume():
	master_volume_slider.set_value_no_signal(MusicPlayer.master_volume * 100.0)
	music_volume_slider.set_value_no_signal(MusicPlayer.music_volume * 100.0)
	config = ConfigFile.new()

func set_master_volume(value: float):
	MusicPlayer.set_master_volume(value)

func set_music_volume(value: float):
	MusicPlayer.set_music_volume(value)

func _on_exit_button_pressed() -> void:
	hide()
