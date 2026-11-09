extends StaticBody2D

@export var flower_scene: PackedScene

var used := false

func _on_head_detector_body_entered(body: Node2D) -> void:
	if used or not body.is_in_group("player"):
		return
	if body.global_position.y <= global_position.y + 8.0:
		return
	used = true
	$Sprite2D.texture = load("res://sprites/tiles/brick.png")
	_spawn_flower()
	var tw := create_tween()
	tw.tween_property($Sprite2D, "position:y", $Sprite2D.position.y - 10.0, 0.08)
	tw.tween_property($Sprite2D, "position:y", $Sprite2D.position.y, 0.12)

func _spawn_flower() -> void:
	if flower_scene == null:
		return
	var f := flower_scene.instantiate()
	f.position = position + Vector2(0.0, -64.0)
	get_parent().add_child(f)
