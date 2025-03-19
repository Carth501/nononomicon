extends ColorRect

@export var coords: Vector2i

func setup(new_coords: Vector2i):
	coords = new_coords
	State.square_changed.connect(compare_coords)

func _on_mouse_entered() -> void:
	State.set_chosen_coords(coords)

func _on_mouse_exited() -> void:
	State.set_chosen_coords(Vector2i(-1, -1))

func get_square_state():
	State.get_position_state(coords)

func compare_coords(updated_square_coords: Vector2i):
	if(updated_square_coords == coords):
		set_square_appearance(State.get_position_state(coords))

func set_square_appearance(square_state: State.SquareStates):
	# https://coolors.co/105e6e-321e1e-4e3636-cd1818-ece2d0
	if(square_state == State.SquareStates.EMPTY):
		set_color(Color('ECE2D0'))
	elif(square_state == State.SquareStates.MARKED):
		set_color(Color('105E6E'))
	elif(square_state == State.SquareStates.FLAGGED):
		set_color(Color('CD1818'))
