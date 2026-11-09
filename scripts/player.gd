extends CharacterBody2D

const SPEED := 260.0
const JUMP_VELOCITY := -620.0
const DOUBLE_JUMP_VELOCITY := -560.0
const GRAVITY := 1500.0
const MAX_JUMPS := 2
const MAX_FALL_SPEED := 900.0

var alive := true
var jumps_used := 0
var attack_timer := 0.0
var anim_timer := 0.0
var anim_frame := 0

@onready var sprite: Sprite2D = $Sprite2D

func _physics_process(delta: float) -> void:
	if not alive:
		velocity.y += GRAVITY * delta
		velocity.y = minf(velocity.y, MAX_FALL_SPEED)
		move_and_slide()
		return

	if is_on_floor():
		jumps_used = 0

	if not is_on_floor():
		velocity.y += GRAVITY * delta
		velocity.y = minf(velocity.y, MAX_FALL_SPEED)

	var direction := Input.get_axis("move_left", "move_right")
	velocity.x = direction * SPEED
	if direction != 0.0:
		sprite.flip_h = direction < 0.0

	if Input.is_action_just_pressed("jump") and jumps_used < MAX_JUMPS:
		velocity.y = JUMP_VELOCITY if jumps_used == 0 else DOUBLE_JUMP_VELOCITY
		jumps_used += 1

	if Input.is_action_just_released("jump") and velocity.y < -180.0:
		velocity.y = -180.0

	if Input.is_action_just_pressed("attack"):
		attack_timer = 0.45
		anim_timer = 0.0
		anim_frame = 0

	move_and_slide()

	for i in get_slide_collision_count():
		var other := get_slide_collision(i).get_collider()
		if other is Node and other.is_in_group("enemy"):
			if velocity.y > 0.0 and global_position.y < other.global_position.y - 12.0:
				other.squash()
				velocity.y = -360.0
			else:
				die()

	if is_on_floor():
		jumps_used = 0

	if global_position.y > 900.0:
		die()

	attack_timer = maxf(attack_timer - delta, 0.0)
	_update_animation(delta, direction)

func _update_animation(delta: float, direction: float) -> void:
	anim_timer += delta
	if attack_timer > 0.0:
		if anim_timer >= 0.08:
			anim_timer = 0.0
			anim_frame = (anim_frame + 1) % 4
		_set_frame("attack", anim_frame)
	elif not is_on_floor():
		if anim_timer >= 0.10:
			anim_timer = 0.0
			anim_frame = (anim_frame + 1) % 4
		_set_frame("jump", anim_frame)
	elif absf(direction) > 0.1:
		if anim_timer >= 0.09:
			anim_timer = 0.0
			anim_frame = (anim_frame + 1) % 4
		_set_frame("walk", anim_frame)
	else:
		if anim_timer >= 0.16:
			anim_timer = 0.0
			anim_frame = (anim_frame + 1) % 4
		_set_frame("idle", anim_frame)

func _set_frame(kind: String, frame: int) -> void:
	var tex := load("res://sprites/cat/%s_%d.png" % [kind, frame % 4]) as Texture2D
	if tex:
		sprite.texture = tex

func die() -> void:
	if not alive:
		return
	alive = false
	GameState.on_player_died()
	_set_frame("attack", 0)
	velocity = Vector2(0.0, -420.0)
	collision_layer = 0
	collision_mask = 0
	await get_tree().create_timer(1.0).timeout
	if not is_inside_tree():
		return
	if GameState.lives > 0:
		get_tree().reload_current_scene()
	else:
		get_tree().change_scene_to_file("res://scenes/cutscene_fail.tscn")
