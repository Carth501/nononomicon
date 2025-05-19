class_name GameUI extends Control

@export var notes_controls: VBoxContainer

func toggle_features(features: FeaturesList):
	notes_controls.visible = features.notes
