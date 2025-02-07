extends CharacterBody2D

@export var max_speed = 1500
@export var acceleration_air = 5000
@export var acceleration_ground = 6000
@export var jump_velocity = 1000
@export var air_friction = 2000
@export var ground_friction = 5000
@export var dir_fric_mult = 0.15
@export var gravity = 2500
@export var max_fall = 5000
@export var jump_buffer_time = 0.03
@export var bunnyhop_speed = 100
@export var coyote_time = 0.1
@export var pull_strength = 3000
@export var grappling_time = 1.5

@export var item: int = 2
@export var just_jumped: bool = false
@export var is_grappling: bool = false
@export var has_grappled: bool = false

var DIRECTION: float
var POS_DELTA_MOUSE: Vector2
var HAS_JUMPED: bool = false
var BUFFER_TIMER_START: bool = false
var COYOTE_TIMER: float = 0
var BUFFER_TIMER: float = 0
var GRAPPLING_TIMER: float = 0
var grappling_conserve = 0.2
signal done_grappling
signal switched_item

func _ready() -> void:
	#position = Vector2(0, -$CollisionShape2D.get_shape().get_rect().size.y/2)
	position = Vector2(10000, -1500)

func _physics_process(delta: float) -> void:
	DIRECTION = Input.get_axis("move_left", "move_right")
	POS_DELTA_MOUSE = position - get_global_mouse_position()
	
	if !is_on_floor():
		if is_grappling:
			velocity.y += gravity * delta * 0.6
		elif just_jumped and velocity.y < -500:
			velocity.y += gravity * delta * 0.3
		else:
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
			BUFFER_TIMER_START = false
		#else:
			#if get_floor_angle() != 0:
			#	velocity.y = get_floor_angle()*velocity.x
	
	if GRAPPLING_TIMER >= grappling_time:
		is_grappling = false
		has_grappled = true
		GRAPPLING_TIMER = 0
		done_grappling.emit()
	
	if Input.is_action_pressed("fire grappling hook") and !has_grappled and (item == 1 or item == 2):
		if $GrapplingHook.result != {}:
			var angle = ($GrapplingHook.result.position - position).angle_to(Vector2(0, -1))
			var V_relative = velocity.rotated(angle)
			if V_relative.y > 0:
				velocity = Vector2(V_relative.x, grappling_conserve *V_relative.y).rotated(-angle)
			is_grappling = true
			just_jumped = false
			velocity += delta * ($GrapplingHook.result.position - position).normalized() * pull_strength
			GRAPPLING_TIMER += delta
			HAS_JUMPED = true
	
	if Input.is_action_just_released("fire grappling hook") and (item == 1 or item == 2):
		is_grappling = false
		has_grappled = true
		GRAPPLING_TIMER = 0
		done_grappling.emit()
	
	if Input.is_action_just_pressed("jump"):
		handle_jump(DIRECTION)
	if Input.is_action_just_pressed("switch_item"):
		item = (item + 1) % 3
		switched_item.emit()
	if not is_grappling:
		handle_friction(DIRECTION,delta)
	handle_movement(DIRECTION,delta)
	if velocity.y > max_fall:
		velocity.y = move_toward(velocity.y, max_fall, 5)
	
	if Input.is_action_just_released("jump") and just_jumped and velocity.y < 0:
		velocity.y = velocity.y/2
		just_jumped = false
	
	if Input.is_action_just_released("jump") and BUFFER_TIMER != 0 and BUFFER_TIMER <= jump_buffer_time:
		BUFFER_TIMER = 0
		BUFFER_TIMER_START = false
	
	move_and_slide()

func handle_jump(DIR) -> void:
	if is_on_floor():
		velocity.y += -jump_velocity
		velocity.x += DIR * bunnyhop_speed
		HAS_JUMPED = true
		just_jumped = true
	else:
		BUFFER_TIMER_START = true
		if COYOTE_TIMER != 0 && COYOTE_TIMER <= coyote_time:
			velocity.y += -jump_velocity
			velocity.x += DIR * bunnyhop_speed
			COYOTE_TIMER = 0
			HAS_JUMPED = true
			just_jumped = true

func handle_movement(DIR,delta) -> void:
	if DIR and (DIR != velocity.x/abs(velocity.x) or abs(velocity.x) < max_speed):
		if is_on_floor():
			velocity.x += DIR * acceleration_ground * delta
		else:
			velocity.x += DIR * acceleration_air * delta

func handle_friction(DIR,delta) -> void:
	if is_on_floor():
		if abs(DIR - velocity.normalized().x) < 1 and DIR != 0:
			velocity.x = move_toward(velocity.x, 0, delta * dir_fric_mult * (ground_friction + 0.1 * abs(velocity.x)))
		else:
			velocity.x = move_toward(velocity.x, 0, delta * (ground_friction + 0.1 * abs(velocity.x)))
	else:
		if abs(DIR - velocity.normalized().x) < 1 and DIR != 0:
			velocity.x = move_toward(velocity.x, 0, delta * dir_fric_mult * (air_friction + 0.1 * abs(velocity.x)))
		else:
			velocity.x = move_toward(velocity.x, 0, delta * (air_friction + 0.1 * abs(velocity.x)))

func die() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().paused = true
	queue_free()
