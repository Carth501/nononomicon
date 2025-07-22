class_name NoteVirtualSwitch extends PanelContainer

@export var note_button: Button
var note_hovering: bool = false

func _ready() -> void:
	State.notes_mode_changed.connect(set_note_panel_no_signal)

func set_note_panel_no_signal(is_notes_mode: bool) -> void:
	note_button.set_pressed_no_signal(is_notes_mode)

func toggle_notes() -> void:
	State.set_notes(!State.get_notes())

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("LeftClick") and note_hovering:
		toggle_notes()

func _on_note_button_container_mouse_exited() -> void:
	note_hovering = false

func _on_note_button_container_mouse_entered() -> void:
	note_hovering = true
