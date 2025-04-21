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
	State.set_active_id('TestKey')
	State.setup({})
	assert_has(State.master ['TestKey'], State.SQUARE_MAP_KEY, "Should have a square map")
	assert_has(State.master ['TestKey'], State.TARGET_MAP_KEY, "Should have a target map")
	assert_has(State.master ['TestKey'], State.HEADERS_KEY, "Should have headers")

func test_parameterized_state_initialization():
	State.set_active_id('TestKey')
	State.setup({'size': Vector2i(4, 4), 'seed': 19024})
	assert_has(State.master ['TestKey'], State.TARGET_MAP_KEY, "Should have headers key")
	assert_eq(State.master ['TestKey'][State.TARGET_MAP_KEY], {
		0: [0, 0, 0, 1],
		1: [1, 1, 1, 0],
		2: [1, 0, 1, 0],
		3: [1, 1, 0, 0]})


class TestStateFunctions:
	extends GutTest

	var parameters = {
		'size': Vector2i(2, 2),
		'seed': 7,
		'target_map': {
			0: [0, 1],
			1: [1, 0]}}

	func before_each():
		State.set_active_id('TestKey')
		State.set_size(parameters['size'])
		State.set_seed(parameters['seed'])
		State.set_target_map(parameters['target_map'])
		State.generate_headers()

	func test_victory_detection_rejection():
		State.generate_empty_map()
		assert_false(State.check_victory(), "Should not have detected victory")

	func test_header_generation():
		var x_header = State.get_header('X')
		assert_true(x_header == {0: [ {"length": "1", "segment": [1]}], 1: [ {"length": "1", "segment": [0]}]}, "Should have generated the correct header")
		var y_header = State.get_header('Y')
		assert_true(y_header == {0: [ {"length": "1", "segment": [1]}], 1: [ {"length": "1", "segment": [0]}]}, "Should have generated the correct header")

	func test_get_duplicate_lengths():
		var lengths = State.get_duplicate_lengths('X')
		assert_true(lengths != {}, "Should have found some duplicates")

	func test_find_offset_function():
		var x_offset_segments = State.find_offset_by_one_segments('X')
		assert_eq(x_offset_segments, [ {"segment1": [1], "segment2": [0], "index1": 0, "index2": 1}], "Should have found the offset segments")

	func test_find_shared_end_segments():
		var x_offset_segments = State.find_offset_by_one_segments('X')
		var y_offset_segments = State.find_offset_by_one_segments('Y')
		var shared_end_segments = State.find_shared_end_segments(x_offset_segments, y_offset_segments)
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
		var point = Vector2i(0, 1)
		assert_eq(changed_points, [point], "Should have changed the point [0, 1] to empty")
		assert_eq(State.get_target_position(point), State.SquareStates.EMPTY, "The changed point should be empty")

	func test_victory_detection_rejection_2():
		var x_offset_segments = State.find_offset_by_one_segments('X')
		var y_offset_segments = State.find_offset_by_one_segments('Y')
		var shared_end_segments = State.find_shared_end_segments(x_offset_segments, y_offset_segments)
		State.resolve_danger_square(shared_end_segments)
		State.set_square_map({0: [0, 1], 1: [1, 0]})
		assert_false(State.check_victory(), "Should not have detected victory")


class TestAdjacencyException:
	extends GutTest

	var parameters = {
		'size': Vector2i(3, 2),
		'seed': 6,
		'target_map': {
			0: [0, 1],
			1: [1, 0],
			2: [0, 1]
			}}

	func before_all():
		State.set_active_id('TestKey')
		State.set_size(parameters['size'])
		State.set_seed(parameters['seed'])
		State.set_target_map(parameters['target_map'])
		State.generate_headers()


	func test_get_duplicate_lengths():
		var lengths = State.get_duplicate_lengths('X')
		assert_eq(lengths, {"1": [ {"x": 0, "segment": [1]}, {"x": 1, "segment": [0]}, {"x": 2, "segment": [1]}]}, "Should have found some duplicates")

	func test_header_generation():
		var x_header = State.get_header('X')
		assert_true(x_header == {
			0: [ {"length": "1", "segment": [1]}],
			1: [ {"length": "1", "segment": [0]}],
			2: [ {"length": "1", "segment": [1]}]}, "Should have generated the correct header")
		var y_header = State.get_header('Y')
		assert_true(y_header == {
			0: [ {"length": "1", "segment": [1]}],
			1: [ {"length": "1", "segment": [0]}, {"length": "1", "segment": [2]}]}, "Should have generated the correct header")

	func test_find_offset_function():
		var x_offset_segments = State.find_offset_by_one_segments('X')
		assert_eq(x_offset_segments,
		[
			{"segment1": [1], "segment2": [0], "index1": 0, "index2": 1},
			{"segment1": [0], "segment2": [1], "index1": 1, "index2": 2}
		], "Should have found the offset segments")

	func test_adjacency_exception():
		var x_offset_segments = State.find_offset_by_one_segments('X')
		var y_offset_segments = State.find_offset_by_one_segments('Y')
		var shared_end_segments = State.find_shared_end_segments(x_offset_segments, y_offset_segments)
		assert_eq(shared_end_segments.size(), 0, "Should have triggered the adjacency exception")

	func test_victory_detection():
		State.generate_empty_map()
		State.cheat_reveal_all_squares()
		print(State.master ['TestKey'][State.SQUARE_MAP_KEY])
		assert_true(State.check_victory(), "Should have detected victory")

class TestComplications:
	extends GutTest

	# var parameters = {
	# 	'size': Vector2i(3, 2),
	# 	'seed': 6,
	# 	'target_map': {
	# 		0: {0: 0, 1: 1},
	# 		1: {0: 1, 1: 0},
	# 		2: {0: 0, 1: 1}},
	# 	"complications": [
	# 		{
	# 			"type": "delta",
	# 			"subject_column": 4,
	# 			"variable_column": 3,
	# 		}
	# 	]}

	# func before_all():
	# 	State.set_active_id('TestKey')
	# 	State.set_size(parameters['size'])
	# 	State.set_seed(parameters['seed'])
	# 	State.set_target_map(parameters['target_map'])
	# 	State.handle_complications(parameters['complications'])
	# 	State.generate_headers()

	func test_generate_delta():
		var header1 = [ {'length': 1, 'segment': [1]}]
		var header2 = [ {'length': 1, 'segment': [0]}, {'length': 1, 'segment': [2]}]
		var delta = State.generate_delta(header1, header2)
		assert_eq(delta, [ {'length': '3', 'segment': [0, 1, 2]}], "Should have found the delta pattern")

	func test_generate_delta_2():
		var header1 = [ {'length': 2, 'segment': [1, 2]}]
		var header2 = [ {'length': 1, 'segment': [0]}, {'length': 1, 'segment': [2]}]
		var delta = State.generate_delta(header1, header2)
		assert_eq(delta, [ {'length': '2', 'segment': [0, 1]}], "Should have found the delta pattern")

	func test_generate_delta_3():
		var header1 = [ {'length': 3, 'segment': [0, 1, 2]}]
		var header2 = [ {'length': 1, 'segment': [0]}, {'length': 1, 'segment': [2]}]
		var delta = State.generate_delta(header1, header2)
		assert_eq(delta, [ {'length': '1', 'segment': [1]}], "Should have found the delta pattern")

	func test_generate_delta_4():
		var header1 = [ {'length': 1, 'segment': [0]}]
		var header2 = [ {'length': 1, 'segment': [0]}, {'length': 1, 'segment': [2]}]
		var delta = State.generate_delta(header1, header2)
		assert_eq(delta, [ {'length': '1', 'segment': [2]}], "Should have found the delta pattern")

	func test_generate_delta_5():
		var header1 = [ {'length': 1, 'segment': [0]}]
		var header2 = [ {'length': 5, 'segment': [0, 1, 2, 3, 4]}]
		var delta = State.generate_delta(header1, header2)
		assert_eq(delta, [ {'length': '4', 'segment': [1, 2, 3, 4]}], "Should have found the delta pattern")

		
class TestDangerSquareSecondCase:
	func before_all():
		State.setup({"seed": 1234, 'size': Vector2i(8, 8)})
		# This one has a danger square that cannot be
		# detected by the current algorithm.
		State.generate_headers()


class TestHeaderAssist:
	extends GutTest

	func test_header_assist_1():
		State.set_active_id('TestKey')
		State.set_target_map({
				0: [0, 1, 0, 1],
				1: [0, 1, 1, 1],
				2: [1, 1, 1, 0],
				3: [0, 1, 0, 1]
			})
		State.set_size(Vector2i(4, 4))
		State.generate_headers()
		State.set_square_map({
			0: [0, 0, 0, 1],
			1: [0, 1, 1, 0],
			2: [0, 0, 1, 1],
			3: [0, 0, 0, 1],
			})
		var comparisons = State.generate_all_line_comparisons()
		assert_eq(comparisons["X"], {0: [true, false], 1: [false], 2: [false], 3: [true, false]}, "Should have generated the correct comparison")
		assert_eq(comparisons["Y"], {0: [false], 1: [false], 2: [true], 3: [true, true]}, "Should have generated the correct comparison")

	func test_header_assist_2():
		State.set_active_id('TestKey')
		State.set_size(Vector2i(1, 7))
		State.set_target_map({
				0: [1, 1, 0, 1, 0, 1, 1],
			})
		State.generate_headers()
		State.set_square_map({
			0: [1, 1, 0, 1, 0, 1, 1],
			})
		var comparisons = State.generate_all_line_comparisons()
		assert_eq(comparisons["X"], {0: [true, true, true]}, "Should have generated the correct comparison")

	func test_header_assist_3():
		State.set_active_id('TestKey')
		State.set_size(Vector2i(1, 7))
		State.set_target_map({
				0: [0, 1, 0, 1, 0, 1, 1],
			})
		State.generate_headers()
		State.set_square_map({
			0: [0, 0, 0, 1, 0, 1, 1],
			})
		var comparisons = State.generate_all_line_comparisons()
		assert_eq(comparisons["X"], {0: [true, false, true]}, "Should have skipped the second length value")

	func test_header_assist_4():
		State.set_active_id('TestKey')
		State.set_size(Vector2i(1, 7))
		State.set_target_map({
				0: [1, 1, 0, 1, 0, 1, 1],
			})
		State.generate_headers()
		State.set_square_map({
			0: [1, 0, 1, 1, 0, 1, 1],
			})
		var comparisons = State.generate_all_line_comparisons()
		assert_eq(comparisons["X"], {0: [true, true, true]}, "Should ignore the lengths being out of order")

	func test_header_assist_5():
		State.set_active_id('TestKey')
		State.set_size(Vector2i(1, 8))
		State.set_target_map({
				0: [1, 0, 0, 0, 0, 0, 1, 1],
		})
		State.generate_headers()
		State.set_square_map({
			0: [1, 0, 1, 1, 1, 0, 1, 1],
			})
		var comparisons = State.generate_all_line_comparisons()
		assert_eq(comparisons["X"], {0: [true, true]}, "Should ignore the extra length")