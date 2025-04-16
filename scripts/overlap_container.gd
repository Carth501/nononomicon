extends Container

@export var primary_control: Control
@export var secondary_controls: Array[Control]


func _on_sort_children() -> void:
	var primary_size = primary_control.size
	size = primary_size
	for node in secondary_controls:
		node.size = primary_size
		node.position = primary_control.position
