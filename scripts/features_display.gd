extends ScrollContainer

@export var feature_item: PackedScene
@export var feature_container: HFlowContainer
var feature_list := {}

func _ready() -> void:
	State.level_changed.connect(handle_features)

func handle_features() -> void:
	var parameters = State.get_level_parameters()
	var features = State.get_level_features()
	handle_notes(features.notes)
	handle_timer(features.timer)
	handle_header_assist(features.header_assist)
	handle_submit_assist(features.submit_button_assist)
	handle_hints(parameters.hints)

func get_feature_item(feature_id: String) -> FeatureItem:
	var item: FeatureItem
	if !feature_list.has(feature_id):
		item = feature_item.instantiate()
		feature_list[feature_id] = item
		feature_container.add_child(item)
	else:
		item = feature_list[feature_id]
	return item

func handle_notes(setting: bool) -> void:
	var item: FeatureItem = get_feature_item("notes")
	item.set_text("Notes") # TODO: Localize this
	item.set_enabled(setting)
	if setting:
		item.description = "An alternative way to mark and flag squares to remember something." # TODO: Localize this
	else:
		item.description = "Disabled" # TODO: Localize this

func handle_timer(setting: bool) -> void:
	var item: FeatureItem = get_feature_item("timer")
	item.set_text("Timer") # TODO: Localize this
	item.set_enabled(setting)
	if setting:
		item.description = "A clock displaying the time recorded on a page." # TODO: Localize this
	else:
		item.description = "Disabled" # TODO: Localize this

func handle_header_assist(assist_level: State.HeaderAssistLevel) -> void:
	var item: FeatureItem = get_feature_item("header_assist")
	item.set_text("Header Assist") # TODO: Localize this
	var setting = assist_level != State.HeaderAssistLevel.NO_ASSIST
	item.set_enabled(setting)
	if setting:
		item.description = "Colors the numbers in the headers to represent their status." # TODO: Localize this
	else:
		item.description = "Disabled" # TODO: Localize this

func handle_hints(hint_list: Array) -> void:
	var item: FeatureItem = get_feature_item("hints")
	item.set_text("Hints") # TODO: Localize this
	var setting = hint_list.size() > 0
	item.set_enabled(setting)
	if setting:
		item.description = "Highlights squares that must be marked, given the situation." # TODO: Localize this
	else:
		item.description = "Disabled" # TODO: Localize this

func handle_submit_assist(setting: bool) -> void:
	var item: FeatureItem = get_feature_item("submit_assist")
	item.set_text("Submission Assist") # TODO: Localize this
	item.set_enabled(setting)
	if setting:
		item.description = "Disables the submit button if the answer has not been found, and highlights it when ready." # TODO: Localize this
	else:
		item.description = "Disabled" # TODO: Localize this
