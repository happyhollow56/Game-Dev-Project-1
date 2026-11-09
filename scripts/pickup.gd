extends Area2D

var collected := false
var base_y := 0.0
var clock := 0.0

@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	base_y = position.y
	body_entered.connect(_on_body_entered)

func _process(delta: float) -> void:
	clock += delta
	position.y = base_y + sin(clock * 3.0) * 6.0

func _on_body_entered(body: Node2D) -> void:
	if collected or not body.is_in_group("player"):
		return
	collected = true
	GameState.add_flower()
	queue_free()
