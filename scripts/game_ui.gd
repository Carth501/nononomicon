class_name GameUI extends Control

@export var notes_controls: VBoxContainer

func toggle_features(features: Dictionary):
	if features.has("notes"):
		notes_controls.visible = features["notes"]
	else:
		notes_controls.visible = true
