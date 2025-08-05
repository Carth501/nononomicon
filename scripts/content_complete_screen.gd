extends Control

var nononomicon: Nononomicon
var fade_timestamp: float = 0.0

func set_nononomicon(new_nononomicon: Nononomicon):
	nononomicon = new_nononomicon

func set_fade_timestamp():
	fade_timestamp = Time.get_ticks_msec()

func _process(delta: float) -> void:
	modulate.a = lerp(modulate.a, 1.0, 1.0 * delta)

func save_game():
	SaveManager.save("ManualSave")

func open_index():
	nononomicon.open_page("index")
	save_game()
	queue_free()

func open_main_menu():
	save_game()
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func exit():
	save_game()
	get_tree().quit()

func exit_without_saving():
	get_tree().quit()
