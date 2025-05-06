extends PanelContainer

var screensize = Vector2()
var adj_pos = Vector2()
var tooltip_label = Label
var offset = Vector2(4, -4)

func _ready() -> void:
	screensize = get_viewport().get_visible_rect().size
	get_viewport().size_changed.connect(_on_size_changed)
	mouse_filter = MouseFilter.MOUSE_FILTER_IGNORE
	tooltip_label = Label.new()
	tooltip_label.name = "TooltipLabel"
	tooltip_label.mouse_filter = MouseFilter.MOUSE_FILTER_IGNORE
	add_child(tooltip_label)
	z_index = 10
	hide()

func _on_size_changed():
	screensize = get_viewport().get_visible_rect().size

func _process(_delta):
	if !is_visible():
		return
	var cursor_pos = get_global_mouse_position()
	adj_pos.x = clamp(cursor_pos.x + offset.x, 0, screensize.x - size.x - 4)
	adj_pos.y = clamp(cursor_pos.y + offset.y - size.y, 0, screensize.y - size.y - 4)
	set_position(adj_pos)

func show_tooltip(text: String):
	show()
	tooltip_label.text = text
	size = Vector2(0, 0)
	await RenderingServer.frame_post_draw
	tooltip_label.text = text

func hide_tooltip():
	hide()
