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
@export var coyote_time = 0.5

@onready var coyote_timer = $Coyote_Timer

var DIRECTION: float
var POS_DELTA: Vector2
var CAN_JUMP: bool = false
var JUMP_BUFFER: bool = false;

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
		if CAN_JUMP:
			if not coyote_timer:
				coyote_timer.start(coyote_time)
		else:
			pass
			#var distance = position - TileMapLayer.position
			#if distance.abs < 30: #this is a bit finicky, switch it for a better condition
				#print(distance) #put walljump code here
	else:
		CAN_JUMP = true
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
		velocity.x = move_toward(velocity.x, 0, ground_friction * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, air_friction * delta)

func handle_recoil_shotgun(POS):
	var RECOIL = POS.normalized() * recoil
	velocity += RECOIL

func handle_jump(DIR):
	if is_on_floor():
		velocity.y -= jump_velocity
		velocity.x += DIR * bunnyhop_speed
		CAN_JUMP = false
	else:
		JUMP_BUFFER = true
		get_tree().create_timer(jump_buffer_timer).timeout.connect(on_jump_buffer_timeout)

func on_jump_buffer_timeout():
	JUMP_BUFFER = false

func on_coyote_timeout():
	CAN_JUMP = false

func handle_forces():
	var forces = null
	velocity += forces
