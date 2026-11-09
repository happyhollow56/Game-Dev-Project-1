extends Control

@export_multiline var story := ""
@export var button_a_text := "Start Game"
@export var button_b_text := ""
@export var next_scene := "res://scenes/level.tscn"
@export var reset_on_start := false

@onready var story_label: Label = $VBox/Story
@onready var button_a: Button = $VBox/ButtonA
@onready var button_b: Button = $VBox/ButtonB

func _ready() -> void:
	story_label.text = story
	button_a.text = button_a_text
	button_b.text = button_b_text
	button_b.visible = not button_b_text.is_empty()
	button_a.pressed.connect(_start)
	button_b.pressed.connect(_quit)

func _start() -> void:
	if reset_on_start:
		GameState.reset()
	get_tree().change_scene_to_file(next_scene)

func _quit() -> void:
	get_tree().quit()
