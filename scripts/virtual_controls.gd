class_name VirtualControls extends VBoxContainer

@export var mark_button: Button
@export var note_button: Button
@export var mark_panel: PanelContainer
@export var note_panel: PanelContainer
var mark_hovering: bool = false
var note_hovering: bool = false

func _ready() -> void:
	State.notes_mode_changed.connect(set_note_panel_no_signal)
	State.inverted_changed.connect(set_mark_panel_no_signal)

func set_note_panel_no_signal(is_notes_mode: bool) -> void:
	note_button.set_pressed_no_signal(is_notes_mode)

func toggle_notes() -> void:
	State.set_notes(!State.get_notes_mode())

func set_mark_panel_no_signal(is_inverted: bool) -> void:
	mark_button.set_pressed_no_signal(is_inverted)

func toggle_mark() -> void:
	State.toggle_inverted()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("LeftClick"):
		if note_hovering:
			toggle_notes()
		elif mark_hovering:
			toggle_mark()
		else:
			return

func _on_note_button_container_mouse_exited() -> void:
	note_hovering = false

func _on_note_button_container_mouse_entered() -> void:
	note_hovering = true

func _on_mark_button_container_mouse_exited() -> void:
	mark_hovering = false

func _on_mark_button_container_mouse_entered() -> void:
	mark_hovering = true
