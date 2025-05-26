class_name VictorySplashController extends Control

enum SplashState {
	OFF,
	GROWING,
	DONE,
	DISABLED
}

@export var object_list: Array[Control] = []
@export var splash_duration: float = 2.0
var opacity: float = 0.0
var splash_state: SplashState = SplashState.OFF
var splash_timer: Timer

func _ready():
	splash_timer = Timer.new()
	splash_timer.wait_time = splash_duration
	splash_timer.one_shot = true
	splash_timer.timeout.connect(_on_splash_timer_timeout)
	add_child(splash_timer)
	toggle_splash(SplashState.OFF)

func toggle_splash(state: SplashState):
	splash_state = state

func _on_splash_timer_timeout():
	toggle_splash(SplashState.DONE)

func start_splash():
	toggle_splash(SplashState.GROWING)

func disable_splash():
	toggle_splash(SplashState.DISABLED)
	opacity = 1.0
	update_splash()

func reset_splash():
	toggle_splash(SplashState.OFF)
	opacity = 1.0
	update_splash()

func finish_splash():
	toggle_splash(SplashState.DONE)
	opacity = 0.0
	update_splash()

func _process(delta: float) -> void:
	if splash_state == SplashState.GROWING:
		opacity -= delta / splash_duration
		update_splash()

func update_splash():
	if opacity <= 0.0:
		opacity = 0.0
		splash_state = SplashState.DONE
	for obj in object_list:
		obj.modulate.a = opacity