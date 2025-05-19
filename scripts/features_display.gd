extends ScrollContainer

@export var feature_item: PackedScene
@export var feature_container: HFlowContainer
var feature_list := {}

func _ready() -> void:
	State.level_changed.connect(handle_features)

func handle_features() -> void:
	pass
	# var features = State.get_level_features()
	# for feature_id in feature_localization_list.keys():
	# 	var item: FeatureItem
	# 	if !feature_list.has(feature_id):
	# 		item = feature_item.instantiate()
	# 		feature_list[feature_id] = item
	# 		feature_container.add_child(item)
	# 	else:
	# 		item = feature_list[feature_id]
	# 	if feature_id == 'header_assist':
	# 		var assist_level = features.header_assist
	# 		var locale_def = feature_localization_list['header_assist']
	# 		item.set_text(locale_def["name"] + ": " +
	# 		locale_def["header_assist_levels"][assist_level])
	# 		if assist_level == 0:
	# 			item.set_enabled(false)
	# 			item.description = "Disabled"
	# 		else:
	# 			item.set_enabled(true)
	# 			item.description = locale_def["description"]
	# 	else:
	# 		var locale_def = feature_localization_list[feature_id]
	# 		item.set_text(locale_def["name"])
	# 		var setting = features.has(feature_id) and features[feature_id]
	# 		item.set_enabled(setting)
	# 		if setting:
	# 			item.description = locale_def["description"]
	# 		else:
	# 			item.description = "Disabled"
