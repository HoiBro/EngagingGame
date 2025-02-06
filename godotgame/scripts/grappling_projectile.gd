extends RigidBody2D

@export var shot_strength = 5000
@export var shot_time = 10000

@onready var grappling_hook = $"../Player/GrapplingHook"

var MPOS: Vector2 = Vector2(0, 0)
var OLD_POS: Vector2 = Vector2(0, 0)
var NEW_POS: Vector2 = Vector2(0, 0)
var TIMER = 0

signal projectile_result

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("fire grappling hook"):
		MPOS = get_local_mouse_position().normalized()
		linear_velocity = Vector2.ZERO
		await grappling_hook.shoot_projectile
		#while true:
			#NEW_POS = position
			#position += Vector2(shot_strength, shot_strength) * MPOS - position
			#TIMER += 1
			#if TIMER > 1000:
				#linear_velocity = Vector2(0, 0)
				#TIMER = 0
				#break
			#else:
				#OLD_POS = NEW_POS
				#print($GrapplingProjectile.position, position)
		#print($GrapplingProjectile.position, position)
		projectile_result.emit()
