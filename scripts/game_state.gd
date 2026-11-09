extends Node

signal flowers_changed(value: int)
signal lives_changed(value: int)

var flowers: int = 0
var lives: int = 3

func _ready() -> void:
	_ensure_action("move_left", [KEY_A, KEY_LEFT])
	_ensure_action("move_right", [KEY_D, KEY_RIGHT])
	_ensure_action("jump", [KEY_SPACE, KEY_K, KEY_UP])
	_ensure_action("attack", [KEY_J, KEY_X])

func _ensure_action(action: String, keys: Array) -> void:
	if not InputMap.has_action(action):
		InputMap.add_action(action)
	for key in keys:
		var event := InputEventKey.new()
		event.physical_keycode = key
		if not InputMap.action_has_event(action, event):
			InputMap.action_add_event(action, event)

func add_flower() -> void:
	flowers += 1
	flowers_changed.emit(flowers)

func on_player_died() -> void:
	flowers = int(flowers / 2)
	lives -= 1
	flowers_changed.emit(flowers)
	lives_changed.emit(lives)

func reset() -> void:
	flowers = 0
	lives = 3
	flowers_changed.emit(flowers)
	lives_changed.emit(lives)
