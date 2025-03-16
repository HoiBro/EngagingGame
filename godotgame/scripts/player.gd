extends CharacterBody2D

@export var max_speed = 1500
@export var acceleration_air = 5000
@export var acceleration_ground = 6000
@export var jump_velocity = 1000
@export var air_friction = 1000
@export var ground_friction = 2500
@export var dir_fric_mult = 0.30
@export var gravity = 2500
@export var max_fall = 5000
@export var jump_buffer_time = 0.06
@export var bunnyhop_speed = 100
@export var coyote_time = 0.1
@export var pull_strength = 3000
@export var grappling_time = 1.5
@export var grappling_conserve = 0.2

@export var just_jumped: bool = false
@export var has_jumped: bool = false
@export var is_grappling: bool = false
@export var has_grappled: bool = false

var DIRECTION: float
var WALKING: bool = false
var POS_DELTA_MOUSE: Vector2
var BUFFER_TIMER_START: bool = false
var COYOTE_TIMER: float = 0
var BUFFER_TIMER: float = 0
var GRAPPLING_TIMER: float = 0

signal died

func _ready() -> void:
	$PlayerCamera.make_current()

func _physics_process(delta: float) -> void:
	DIRECTION = Input.get_axis("move_left", "move_right")
	if DIRECTION == 0:
		WALKING = false
	POS_DELTA_MOUSE = position - get_global_mouse_position()
	
	if !is_on_floor():
		#Apply gravity in the air
		if is_grappling:
			velocity.y += gravity * delta * 0.6
		elif just_jumped and velocity.y < -500:
			velocity.y += gravity * delta * 0.3
		else:
			velocity.y += gravity * delta
		
		#Buffer checks
		if BUFFER_TIMER_START:
			BUFFER_TIMER += delta
		if BUFFER_TIMER > jump_buffer_time:
			BUFFER_TIMER = 0
			BUFFER_TIMER_START = false
		
		#Coyote time checks
		if !has_jumped:
			COYOTE_TIMER += delta
			if COYOTE_TIMER > coyote_time:
				COYOTE_TIMER = 0
				has_jumped = true
		
	else: #If on floor
		has_jumped = false
		just_jumped = false
		has_grappled = false
		COYOTE_TIMER = 0
		if BUFFER_TIMER != 0 and BUFFER_TIMER <= jump_buffer_time:
			handle_jump(DIRECTION)
			BUFFER_TIMER = 0
			BUFFER_TIMER_START = false
	
	#Grappling physics
	if is_grappling:
		#Grappling done
		if GRAPPLING_TIMER >= grappling_time or !Input.is_action_pressed(&"fire grappling hook"):
			is_grappling = false
			has_grappled = true
			GRAPPLING_TIMER = 0
		else:
			var angle = ($GrapplingHook.result.position - position).angle_to(Vector2(0, -1))
			var V_relative = velocity.rotated(angle)
			if V_relative.y > 0:
				velocity = Vector2(V_relative.x, grappling_conserve * V_relative.y).rotated(-angle)
			velocity += delta * ($GrapplingHook.result.position - position).normalized() * pull_strength
			GRAPPLING_TIMER += delta
			just_jumped = false
			has_jumped = true
	
	if Input.is_action_just_pressed("jump"):
		handle_jump(DIRECTION)
	handle_movement(DIRECTION,delta)
	
	if !is_grappling:
		handle_friction(DIRECTION, delta)
	
	if velocity.y > max_fall:
		velocity.y = move_toward(velocity.y, max_fall, 4000*delta)
	
	if Input.is_action_just_released("jump") and just_jumped and velocity.y < 0:
		velocity.y = velocity.y/2
		just_jumped = false
	
	if Input.is_action_just_released("jump") and BUFFER_TIMER != 0 and BUFFER_TIMER <= jump_buffer_time:
		BUFFER_TIMER = 0
		BUFFER_TIMER_START = false
	
	move_and_slide()
	
	if abs(get_real_velocity().x) > abs(velocity.x):
		velocity.x = get_real_velocity().x
	velocity.y = get_real_velocity().y

func handle_jump(DIR) -> void:
	if is_on_floor():
		jump(DIR)
	elif COYOTE_TIMER != 0 and COYOTE_TIMER <= coyote_time:
		jump(DIR)
		COYOTE_TIMER = 0
	else:
		BUFFER_TIMER_START = true

func jump(DIR) -> void:
	velocity.y = -jump_velocity
	velocity.x += DIR * bunnyhop_speed
	has_jumped = true
	just_jumped = true
	$Jump.play()

func handle_movement(DIR,delta) -> void:
	if DIR and (DIR != velocity.x/abs(velocity.x) or abs(velocity.x) < max_speed):
		if is_on_floor():
			velocity.x += DIR * acceleration_ground * delta
			if not WALKING:
				WALKING = true
				walking()
		else:
			velocity.x += DIR * acceleration_air * delta

func walking():
	if WALKING:
		$Walk.play()
		get_tree().create_timer(0.1, false).timeout.connect(walking)

func handle_friction(DIR,delta) -> void:
	if is_on_floor():
		if abs(DIR - velocity.normalized().x) < 1 and DIR != 0:
			velocity.x = move_toward(velocity.x, 0, delta * dir_fric_mult * (ground_friction + 1 * abs(velocity.x)))
		else:
			velocity.x = move_toward(velocity.x, 0, delta * (ground_friction + 1 * abs(velocity.x)))
	else:
		if abs(DIR - velocity.normalized().x) < 1 and DIR != 0:
			velocity.x = move_toward(velocity.x, 0, delta * dir_fric_mult * (air_friction + 0.35 * abs(velocity.x)))
		else:
			velocity.x = move_toward(velocity.x, 0, delta * (air_friction + 0.35 * abs(velocity.x)))

func death() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().paused = true
	$"../WorldCamera".position = position
	$"../WorldCamera".zoom = $PlayerCamera.zoom + Vector2(0.01, 0.01)
	died.emit()
	$"../PlayerDeath".play()
	queue_free()
