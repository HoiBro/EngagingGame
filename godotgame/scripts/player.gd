extends CharacterBody2D

@export var max_speed = 1000
@export var acceleration_ground = 6000
@export var acceleration_air = 2500
@export var jump_velocity = 750
@export var air_friction = 200
@export var ground_friction = 3000
@export var recoil = 1200
@export var jump_buffer_timer = 0.07
@export var bunnyhop_speed = 50

var DIRECTION: float
var JUMP_BUFFER: bool = false;
var POS_DELTA: Vector2

func _input(event):
	if event.is_action_pressed(&"fire shotgun"):
		handle_recoil_shotgun(POS_DELTA)
	if event.is_action_pressed(&"jump"):
		handle_jump(DIRECTION)

func _physics_process(delta: float) -> void:
	DIRECTION = Input.get_axis("move_left", "move_right")
	POS_DELTA = position - get_global_mouse_position()

	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		if JUMP_BUFFER:
			handle_jump(DIRECTION)
			JUMP_BUFFER = false
	
	handle_friction(delta)
	handle_movement(DIRECTION,delta)
	
	move_and_slide()

func handle_movement(DIR,delta):
	if DIR:
		if abs(velocity.x) < max_speed:
			if is_on_floor():
				velocity.x += DIR * acceleration_ground * delta
			else:
				velocity.x += DIR * acceleration_air * delta

func handle_friction(delta):
	if is_on_floor():
		if abs(velocity.x) > 0:
			if velocity.x > 0:
				velocity.x -= ground_friction * delta
				if velocity.x < 0:
					velocity.x = 0
			else:
				velocity.x += ground_friction * delta
				if velocity.x > 0:
					velocity.x = 0
		## move_toward(velocity.x, 0, ground_friction * delta) wil niet werken, weet ook niet waarom
	else:
		if abs(velocity.x) > 0:
			if velocity.x > 0:
				velocity.x -= air_friction * delta
			else:
				velocity.x += air_friction * delta

func handle_recoil_shotgun(POS):
	var RECOIL = POS.normalized() * recoil
	velocity += RECOIL

func handle_jump(DIR):
	if is_on_floor():
		velocity.y -= jump_velocity
		velocity.x += DIR * bunnyhop_speed
	elif is_on_wall():
		velocity += get_wall_normal() * jump_velocity
	else:
		JUMP_BUFFER = true
		get_tree().create_timer(jump_buffer_timer).timeout.connect(on_jump_buffer_timeout)

func on_jump_buffer_timeout():
	JUMP_BUFFER = false
