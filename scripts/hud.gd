extends CanvasLayer

@onready var label: Label = $Label

func _ready() -> void:
	GameState.flowers_changed.connect(_refresh)
	GameState.lives_changed.connect(_refresh)
	_refresh()

func _refresh(_value: int = 0) -> void:
	label.text = "Flowers: %d / 12\nLives: %d" % [GameState.flowers, GameState.lives]
