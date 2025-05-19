class_name XHeader extends Control

@export var numbers_container: VBoxContainer
@export var highlighter_rect: ColorRect
@export var error_rect: ColorRect
@export var complication_rect: ColorRect
var labels: Array = []

func generate_labels(values: Array):
	for i in values:
		var new_label = Label.new()
		new_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		new_label.set_text(i.length)
		numbers_container.add_child(new_label)
		labels.append(new_label)

func set_highlighter(value: bool):
	highlighter_rect.visible = value

func set_error(value: bool):
	error_rect.visible = value

func set_complication(value: bool):
	complication_rect.visible = value

func set_assist(comparison: Array):
	if labels.size() != comparison.size():
		push_error("something went wrong with the comparison. ", labels.size(), " != ", comparison.size(), "\n",
			"comparison: ", comparison)
		return
	for i in range(labels.size()):
		if comparison[i]['length']:
			if comparison[i].has('location') and comparison[i]['location']:
				labels[i].set("theme_override_colors/font_color", Color('#837386'))
			else:
				labels[i].set("theme_override_colors/font_color", Color('#82ed72'))
		else:
			labels[i].remove_theme_color_override("font_color")
