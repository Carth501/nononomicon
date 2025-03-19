extends ScrollContainer

func get_percent_x() -> float:
	var max = get_h_scroll_bar().max_value
	return float(scroll_horizontal) / max

func get_percent_y() -> float:
	var max = get_v_scroll_bar().max_value
	return float(scroll_vertical) / max
