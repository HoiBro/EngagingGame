extends CharacterBody2D

@export var SPEED = 1000
@export var JUMP_VELOCITY = -400.0
@export var AIR_FRICTION = 2000
@export var GROUND_FRICTION = 5000


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = velocity.x + direction * delta * SPEED
	elif is_on_floor():
		velocity.x = move_toward(velocity.x, 0, GROUND_FRICTION * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, AIR_FRICTION * delta)

	move_and_slide()
