class_name TutorialAudioLibrary extends Node

@export var audio_library: Dictionary

func play_audio_for_level(level_id: String):
	var audio_data = audio_library.get(level_id, null)
	if audio_data == null:
		print("No audio data found for level: ", level_id)
		return
	MusicPlayer.play_voice_track(audio_data)