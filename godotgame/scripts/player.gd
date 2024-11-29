extends CharacterBody2D

@export var max_speed = 1000
@export var acceleration_ground = 6000
@export var acceleration_air = 2500
@export var jump_velocity = 750
@export var air_friction = 200
@export var ground_friction = 3000
@export var jump_buffer_time = 0.03
@export var bunnyhop_speed = 50
@export var coyote_time = 0.1

var DIRECTION: float
var POS_DELTA_MOUSE: Vector2
var HAS_JUMPED: bool = false
var BUFFER_TIMER_START: bool = false
var COYOTE_TIMER: float = 0
var BUFFER_TIMER: float = 0

func _ready() -> void:
	position = Vector2(0, -$CollisionShape2D.get_shape().get_rect().size.y/2)

func _input(event) -> void:
	if event.is_action_pressed(&"jump"):
		handle_jump(DIRECTION)

func _physics_process(delta: float) -> void:
	DIRECTION = Input.get_axis("move_left", "move_right")
	POS_DELTA_MOUSE = position - get_global_mouse_position()
	
	if !is_on_floor():
		velocity += get_gravity() * delta
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
		COYOTE_TIMER = 0
		if BUFFER_TIMER != 0 && BUFFER_TIMER <= jump_buffer_time:
			handle_jump(DIRECTION)
			BUFFER_TIMER = 0
	
	handle_friction(delta)
	handle_movement(DIRECTION,delta)
	
	move_and_slide()

func handle_jump(DIR) -> void:
	if is_on_floor():
		velocity.y -= jump_velocity
		velocity.x += DIR * bunnyhop_speed
		HAS_JUMPED = true
	else:
		BUFFER_TIMER_START = true
		if COYOTE_TIMER != 0 && COYOTE_TIMER <= coyote_time:
			velocity.y -= jump_velocity
			velocity.x += DIR * bunnyhop_speed
	get_parent().get_child(4).position = position

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
