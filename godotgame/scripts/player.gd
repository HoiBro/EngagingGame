extends CharacterBody2D

@export var max_speed = 1000
@export var acceleration_ground = 6000
@export var acceleration_air = 1000
@export var jump_velocity = 750.0
@export var air_friction = 200
@export var ground_friction = 5000


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y -= jump_velocity
		elif is_on_wall():
			velocity += get_wall_normal() * jump_velocity
			print(get_wall_normal())
	
	
	# Get the input direction and handle the movement/deceleration.
	var DIRECTION = Input.get_axis("move_left", "move_right")

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
			else:
				velocity.x += ground_friction * delta
		## move_toward(velocity.x, 0, ground_friction * delta) wil niet werken, weet ook niet waarom
	else:
		if abs(velocity.x) > 0:
			if velocity.x > 0:
				velocity.x -= air_friction * delta
			else:
				velocity.x += air_friction * delta

func handle_recoil_shotgun():
	pass
	get_global_mouse_position()
