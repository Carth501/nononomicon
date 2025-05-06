class_name DragDisplayHandler extends Node

func _ready() -> void:
	State.drag_begun.connect(_on_drag_begun)
	State.drag_length_changed.connect(_on_drag_length_changed)
	State.drag_ended.connect(_on_drag_ended)

func _on_drag_begun() -> void:
	GlobalTooltip.show_tooltip('1')

func _on_drag_length_changed(length: int) -> void:
	GlobalTooltip.show_tooltip(str(length))

func _on_drag_ended() -> void:
	GlobalTooltip.hide_tooltip()