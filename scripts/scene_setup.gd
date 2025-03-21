extends Node

func _ready():
	State.setup({"seed": 1234, 'size': Vector2i(3, 3)})