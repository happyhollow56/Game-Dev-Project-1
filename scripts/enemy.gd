extends CharacterBody2D

@export var speed: float = 75.0
@export var patrol_distance: float = 150.0
@export var gravity: float = 1500.0

var direction: float = -1.0
var start_x: float = 0.0
var anim_clock: float = 0.0
var anim_frame: int = 0
var squashed: bool = false

@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	start_x = global_position.x
	sprite.flip_h = direction < 0.0

func _physics_process(delta: float) -> void:
	if squashed:
		return

	if not is_on_floor():
		velocity.y = minf(velocity.y + gravity * delta, 900.0)
	else:
		velocity.y = 0.0

	if global_position.x <= start_x - patrol_distance:
		direction = 1.0
	elif global_position.x >= start_x + patrol_distance:
		direction = -1.0

	velocity.x = direction * speed
	sprite.flip_h = direction < 0.0
	move_and_slide()

	if is_on_wall():
		direction *= -1.0

	_update_walk_animation(delta)

func _update_walk_animation(delta: float) -> void:
	anim_clock += delta
	if anim_clock < 0.12:
		return
	anim_clock = 0.0
	anim_frame = (anim_frame + 1) % 4
	var texture_path := "res://sprites/enemy/walk_%d.png" % anim_frame
	var frame_texture := load(texture_path) as Texture2D
	if frame_texture != null:
		sprite.texture = frame_texture

func squash() -> void:
	if squashed:
		return
	squashed = true
	velocity = Vector2.ZERO
	$CollisionShape2D.set_deferred("disabled", true)
	var tween := create_tween()
	tween.tween_property(sprite, "scale:y", 0.25, 0.12)
	tween.tween_property(self, "modulate:a", 0.0, 0.18)
	tween.tween_callback(queue_free)
