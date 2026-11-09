extends Node2D

func _ready() -> void:
	var camera := get_node_or_null("Player/Camera2D")
	if camera:
		camera.make_current()
