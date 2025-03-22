extends GutTest
func before_each():
	gut.p("ran setup", 2)

func after_each():
	gut.p("ran teardown", 2)

func before_all():
	gut.p("ran run setup", 2)

func after_all():
	gut.p("ran run teardown", 2)

func test_assert_eq_number_equal():
	assert_eq('asdf', 'asdf', "Should pass")

func test_assert_true_with_true():
	assert_true(true, "Should pass, true is true")

func test_state_initialization():
	State.setup({})
	assert_has(State.master , State.SQUARE_MAP_KEY, "Should have a square map")
	assert_has(State.master , State.TARGET_MAP_KEY, "Should have a target map")
	assert_has(State.master , State.HEADERS_KEY, "Should have headers")

func test_parameterized_state_initialization():
	State.setup({'size': Vector2i(4, 4), 'seed': 19024})
	assert_has(State.master , State.TARGET_MAP_KEY, "Should have headers key")
	assert_eq(State.master [State.TARGET_MAP_KEY], {0: {0: 0, 1: 0, 2: 0, 3: 1}, 1: {0: 1, 1: 1, 2: 1, 3: 0}, 2: {0: 1, 1: 0, 2: 1, 3: 0}, 3: {0: 1, 1: 1, 2: 0, 3: 0}})

class TestStateFunctions:
	extends GutTest

	var parameters = {'size': Vector2i(2, 2), 'seed': 6, 'target_map': {0: {0: 0, 1: 1}, 1: {0: 1, 1: 0}}}

	func before_all():
		State.set_size(parameters['size'])
		State.set_target_map(parameters['target_map'])
		State.generate_headers()

	func test_get_duplicate_lengths():
		var lengths = State.get_duplicate_lengths('X')
		assert_true(lengths != {}, "Should have found some duplicates")


	func test_find_offset_function():
		var x_offset_segments = State.find_offset_by_one_segments('X')
		assert_true(x_offset_segments == {"1_0_1": {"segment1": [1], "segment2": [0], "index1": 0, "index2": 1}}, "Should have found the offset segments")

	func test_find_shared_end_segments():
		var x_offset_segments = State.find_offset_by_one_segments('X')
		var y_offset_segments = State.find_offset_by_one_segments('Y')
		var shared_end_segments = State.find_shared_end_segments(x_offset_segments, y_offset_segments)
		print("shared_end_segments ", shared_end_segments)
		assert_true(shared_end_segments.size() > 0, "Should have found shared end segments")
		assert_true(shared_end_segments[0].has('x'), "Shared segment should have 'x' key")
		assert_true(shared_end_segments[0].has('y'), "Shared segment should have 'y' key")
		assert_true(shared_end_segments[0].has('unmarked_corners'), "Shared segment should have 'unmarked_corners' key")
		assert_true(shared_end_segments[0]['x'] == {"segment1": [1], "segment2": [0], "index1": 0, "index2": 1}, "Should have found the x points")
		assert_true(shared_end_segments[0]['y'] == {"segment1": [1], "segment2": [0], "index1": 0, "index2": 1}, "Should have found the y points")
		var point1 = Vector2i(0, 0)
		var point2 = Vector2i(1, 1)
		assert_true(shared_end_segments[0]['unmarked_corners'] == [point1, point2], "Should have found the unmarked corners")

	func test_resolve_danger_square():
		var x_offset_segments = State.find_offset_by_one_segments('X')
		var y_offset_segments = State.find_offset_by_one_segments('Y')
		var shared_end_segments = State.find_shared_end_segments(x_offset_segments, y_offset_segments)
		var changed_points = State.resolve_danger_square(shared_end_segments)
		print("changed_points ", changed_points)
		var point = Vector2i(0, 1)
		assert_true((changed_points == [point]), "Should have changed the point [0, 1] to empty")
		assert_true(State.get_target_position(point) == State.SquareStates.EMPTY, "The changed point should be empty")
