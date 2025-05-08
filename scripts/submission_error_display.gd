class_name SubmissionErrorDisplay extends GridContainer

var icon_list: Array
var full_icon = preload("res://assets/icons/circle-black-shape-svgrepo-com.svg")
var empty_icon = preload("res://assets/icons/circle-ring-svgrepo-com.svg")

func create_list(count: int):
	for i in icon_list:
		i.queue_free()
	icon_list.clear()
	for i in range(count):
		create_slot()
		icon_list[i].texture = empty_icon
	columns = ceil(sqrt(count))

func set_error_count(count: int):
	for i in range(count):
		if (i >= icon_list.size()):
			create_slot()
			columns = ceil(sqrt(icon_list.size()))
		icon_list[i].texture = full_icon

func create_slot():
	var icon = TextureRect.new()
	icon_list.append(icon)
	add_child(icon)
	icon.stretch_mode = TextureRect.EXPAND_IGNORE_SIZE
