extends Node

signal save_file_list_changed

func get_save_file_list():
	var dir = DirAccess.open("user://")
	if (!dir.dir_exists("user://saves")):
		dir.make_dir("user://saves")
	var save_files = DirAccess.get_files_at("user://saves")
	save_file_list_changed.emit()
	return save_files

func save(filename: String):
	var dir = DirAccess.open("user://")
	if (!dir.dir_exists("user://saves")):
		dir.make_dir("user://saves")
	var save_name = "user://saves/%s.nononosave" % filename
	var save_file = FileAccess.open(save_name, FileAccess.WRITE)
	save_file.store_var(State.master )
	save_file.close()

func load(filename: String):
	var dir = DirAccess.open("user://")
	if (!dir.dir_exists("user://saves")):
		dir.make_dir("user://saves")
	var save_name = "user://saves/%s" % filename
	var save_file = FileAccess.open(save_name, FileAccess.READ)
	var save_data = save_file.get_var()
	save_file.close()
	State.load_save(save_data)
