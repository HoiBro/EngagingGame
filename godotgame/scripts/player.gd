extends CharacterBody2D

@export var max_speed = 1000
@export var acceleration_ground = 6000
@export var acceleration_air = 2500
@export var jump_velocity = 750
@export var air_friction = 200
@export var ground_friction = 3000
@export var gravity = 1000
@export var jump_buffer_time = 0.03
@export var bunnyhop_speed = 50
@export var coyote_time = 0.1
@export var just_jumped: bool = false
@export var pull_strength = 10
@export var can_grapple: bool = true

var DIRECTION: float
var POS_DELTA_MOUSE: Vector2
var HAS_JUMPED: bool = false
var BUFFER_TIMER_START: bool = false
var COYOTE_TIMER: float = 0
var BUFFER_TIMER: float = 0

func _ready() -> void:
	position = Vector2(0, -$CollisionShape2D.get_shape().get_rect().size.y/2)

func _physics_process(delta: float) -> void:
	DIRECTION = Input.get_axis("move_left", "move_right")
	POS_DELTA_MOUSE = position - get_global_mouse_position()
	
	if !is_on_floor():
		velocity.y += gravity * delta
		if velocity.y > -200:
			velocity.y += gravity * delta
		if BUFFER_TIMER_START:
			BUFFER_TIMER += delta
		if BUFFER_TIMER > jump_buffer_time:
			BUFFER_TIMER = 0
			BUFFER_TIMER_START = false
		if !HAS_JUMPED:
			COYOTE_TIMER += delta
			if COYOTE_TIMER > coyote_time:
				COYOTE_TIMER = 0
				HAS_JUMPED = true
		else:
			pass
			#var distance = position - TileMapLayer.position #distance to tilemap is hard to get
			#if distance.abs < 30:
				#print(distance) #put walljump code here
	else:
		HAS_JUMPED = false
		just_jumped = false
		COYOTE_TIMER = 0
		if BUFFER_TIMER != 0 && BUFFER_TIMER <= jump_buffer_time:
			handle_jump(DIRECTION)
			BUFFER_TIMER = 0
	
	if Input.is_action_pressed("fire grappling hook") and $GrapplingHook.is_pulling and can_grapple:
		velocity += delta * ($GrapplingHook.result.position - position) * pull_strength
	
	if Input.is_action_just_released("fire grappling hook") and !$GrapplingHook.ready_to_fire:
		can_grapple = false
	
	if Input.is_action_just_pressed("jump"):
		handle_jump(DIRECTION)
	handle_friction(delta)
	handle_movement(DIRECTION,delta)
	
	if Input.is_action_just_released("jump") and just_jumped and velocity.y < 0:
		velocity.y -= velocity.y/2
		just_jumped = false
	
	if Input.is_action_just_released("jump") and BUFFER_TIMER != 0 and BUFFER_TIMER <= jump_buffer_time:
		BUFFER_TIMER = 0
		just_jumped = false
	
	move_and_slide()

func handle_jump(DIR) -> void:
	if is_on_floor():
		velocity.y -= jump_velocity
		velocity.x += DIR * bunnyhop_speed
		HAS_JUMPED = true
		just_jumped = true
	else:
		BUFFER_TIMER_START = true
		if COYOTE_TIMER != 0 && COYOTE_TIMER <= coyote_time:
			velocity.y -= jump_velocity
			velocity.x += DIR * bunnyhop_speed
			COYOTE_TIMER = 0
			HAS_JUMPED = true
			just_jumped = true

func handle_movement(DIR,delta) -> void:
	if DIR && abs(velocity.x) < max_speed:
		if is_on_floor():
			velocity.x += DIR * acceleration_ground * delta
		else:
			velocity.x += DIR * acceleration_air * delta

func handle_friction(delta) -> void:
	if is_on_floor():
		velocity.x = move_toward(velocity.x, 0, ground_friction * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, air_friction * delta)
