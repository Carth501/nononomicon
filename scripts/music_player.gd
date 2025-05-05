extends Node

var audio_player: AudioStreamPlayer
var tracks = [
	preload("res://assets/OST/1. This Place Gives Me The Creeps.wav"),
	preload("res://assets/OST/2. Puzzle Quests Aren't For The Weak.wav"),
	preload("res://assets/OST/3. Is This Thing Cursed.wav"),
	preload("res://assets/OST/4. Floating Mantras.wav"),
	preload("res://assets/OST/5. Good Heavens!.wav"),
	preload("res://assets/OST/6. Tick Tock Goes The Clock.wav"),
]

func _ready():
	audio_player = AudioStreamPlayer.new()
	add_child(audio_player)
	audio_player.finished.connect(next_track)
	next_track()

func next_track():
	var track = tracks[randi() % tracks.size()]
	audio_player.set_stream(track)
	audio_player.set_volume_db(-20)
	audio_player.play()