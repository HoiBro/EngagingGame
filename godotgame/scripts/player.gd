extends CharacterBody2D

@export var max_speed = 1000
@export var acceleration_ground = 5000
@export var acceleration_air = 1000
@export var jump_velocity = -750.0
@export var air_friction = 2000
@export var ground_friction = 5000


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
	
	# Get the input direction and handle the movement/deceleration.
	var DIRECTION = Input.get_axis("move_left", "move_right")

	handle_friction(DIRECTION,delta)
	handle_movement(DIRECTION,delta)
	
	move_and_slide()

func handle_movement(DIR,delta):
	if DIR:
		if abs(velocity.x) < max_speed:
			if is_on_floor():
				velocity.x += DIR * acceleration_ground * delta
			else:
				velocity.x += DIR * acceleration_air * delta
				print(velocity.x)

func handle_friction(DIR,delta):
	if is_on_floor():
		if velocity.x > 0:
			velocity.x -= ground_friction * delta
		else:
			velocity.x += ground_friction * delta
		## move_toward(velocity.x, 0, ground_friction * delta) wil niet werken, weet ook niet waarom
	else:
		move_toward(velocity.x, 0, air_friction * delta)
