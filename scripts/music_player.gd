extends Node

signal music_volume_changed

var music_player: AudioStreamPlayer
var tracks = [
	preload("res://assets/OST/1. This Place Gives Me The Creeps.wav"),
	preload("res://assets/OST/2. Puzzle Quests Aren't For The Weak.wav"),
	preload("res://assets/OST/3. Is This Thing Cursed.wav"),
	preload("res://assets/OST/4. Floating Mantras.wav"),
	preload("res://assets/OST/5. Good Heavens!.wav"),
	preload("res://assets/OST/6. Tick Tock Goes The Clock.wav"),
]
var master_volume = 0.5
var music_volume = 0.5


func _ready():
	await ConfigHandler.ready
	music_player = AudioStreamPlayer.new()
	add_child(music_player)
	music_player.finished.connect(next_track)
	next_track()
	read_config()

func next_track():
	var track = tracks[randi() % tracks.size()]
	music_player.set_stream(track)
	var product_volume = master_volume * music_volume
	music_player.set_volume_db(scale_value(product_volume))
	music_player.play()

func set_master_volume(value: float):
	master_volume = value / 100.0
	ConfigHandler.update_setting("master_volume", value)
	var product_volume = master_volume * music_volume
	music_player.set_volume_db(scale_value(product_volume))

func set_music_volume(value: float):
	music_volume = value / 100.0
	ConfigHandler.update_setting("music_volume", value)
	var product_volume = master_volume * music_volume
	music_player.set_volume_db(scale_value(product_volume))

func set_master_volume_no_save(value: float):
	master_volume = value / 100.0
	var product_volume = master_volume * music_volume
	music_player.set_volume_db(scale_value(product_volume))

func set_music_volume_no_save(value: float):
	music_volume = value / 100.0
	var product_volume = master_volume * music_volume
	music_player.set_volume_db(scale_value(product_volume))

func scale_value(value: float) -> float:
	return linear_to_db(value)

func read_config():
	master_volume = ConfigHandler.get_setting("master_volume")
	if master_volume == null:
		master_volume = 50
	set_master_volume_no_save(master_volume)
	music_volume = ConfigHandler.get_setting("music_volume")
	if music_volume == null:
		music_volume = 50
	set_music_volume_no_save(music_volume)
	music_volume_changed.emit()
