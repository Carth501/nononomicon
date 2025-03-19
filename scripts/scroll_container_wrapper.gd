extends ScrollContainer

func get_percent_x() -> float:
	var max_x = get_h_scroll_bar().max_value
	return float(scroll_horizontal) / max_x

func get_percent_y() -> float:
	var max_y = get_v_scroll_bar().max_value
	return float(scroll_vertical) / max_y
