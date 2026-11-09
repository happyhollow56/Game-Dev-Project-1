extends Area2D

const FLOWERS_TO_WIN := 12

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
	if GameState.flowers >= FLOWERS_TO_WIN:
		get_tree().change_scene_to_file("res://scenes/cutscene_win.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/cutscene_fail.tscn")
