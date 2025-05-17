## The list of small features for a level.
## 
## The little details and features that a level 
## provides, such as notes and header assistance.
class_name FeaturesList extends Resource

@export var notes: bool = true
@export var timer: bool = true
@export var header_assist: State.HeaderAssistLevel = State.HeaderAssistLevel.LENGTH
@export var submit_button_assist: bool = false
@export var percent_marked: bool = false