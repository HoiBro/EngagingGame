extends CharacterBody2D

@export var speed = 1000
@export var jump_velocity = -400.0
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
	
	if DIRECTION:
		if is_on_floor():
			if((velocity.x > 0) != (DIRECTION > 0) and velocity.x != 0):
				velocity.x = move_toward(velocity.x, 0, (ground_friction + DIRECTION * speed) * delta)
			else:
				velocity.x = move_toward(velocity.x, DIRECTION * speed, ground_friction * delta)
		else:
			velocity.x = move_toward(velocity.x, DIRECTION * speed, air_friction * delta)
	else:
		if is_on_floor():
			velocity.x = move_toward(velocity.x, 0, ground_friction * delta)
		else:
			velocity.x = move_toward(velocity.x, 0, air_friction * delta)

	move_and_slide()
