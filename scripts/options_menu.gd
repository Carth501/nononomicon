class_name OptionsMenu extends PanelContainer

@export var master_volume_slider: Slider
@export var music_volume_slider: Slider

func _ready():
	master_volume_slider.value = MusicPlayer.master_volume * 100.0
	music_volume_slider.value = MusicPlayer.music_volume * 100.0

	# master_volume_slider.value_changed.connect(MusicPlayer._on_master_volume_changed)
	# music_volume_slider.value_changed.connect(MusicPlayer._on_music_volume_changed)

func set_master_volume(value: float):
	MusicPlayer.set_master_volume(value)

func set_music_volume(value: float):
	MusicPlayer.set_music_volume(value)

func _on_exit_button_pressed() -> void:
	hide()
