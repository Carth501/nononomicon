class_name MarkFlagVirtualSwitch extends PanelContainer

@export var mark_button: Button
var mark_hovering: bool = false

func _ready() -> void:
	State.inverted_changed.connect(set_mark_panel_no_signal)

func set_mark_panel_no_signal(is_inverted: bool) -> void:
	mark_button.set_pressed_no_signal(is_inverted)

func toggle_mark() -> void:
	State.toggle_inverted()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("LeftClick") and mark_hovering:
		toggle_mark()

func _on_mark_button_container_mouse_exited() -> void:
	mark_hovering = false

func _on_mark_button_container_mouse_entered() -> void:
	mark_hovering = true
