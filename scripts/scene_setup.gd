extends Node

func _ready():
	State.setup({"seed": 1235, 'size': Vector2i(8, 8)})
	# State.setup({"seed": 1234, 'size': Vector2i(8, 8)}) 
	# This one has a danger square that cannot be
	# detected by the current algorithm.