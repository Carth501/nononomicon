class_name GameUI extends Control

@export var notes_switch: Button

func toggle_features(features: Dictionary):
	if features.has("notes"):
		notes_switch.visible = features["notes"]
	else:
		notes_switch.visible = true
