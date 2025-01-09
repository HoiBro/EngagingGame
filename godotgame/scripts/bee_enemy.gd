extends RigidBody2D

@export var enemy_stats = {
	"health": 20
}
@export var max_speed = 10
@export var accel = Vector2(1, 1)
@export var friction = 10

@onready var player = $"../Player"
@onready var shotgun = $"../Player/Shotgun"

var TIME: float = 0
var DIRECTION
var A = Vector2(0, 0)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"fire shotgun"):
		await shotgun.raycast_result
		if (shotgun.result != {} and shotgun.result.collider != null and 
			shotgun.result.collider.get_class() == "RigidBody2D" and shotgun.result.rid == get_rid()):
				enemy_stats.health -= 10
		if enemy_stats.health <= 0:
			queue_free()
		print(enemy_stats.health, position)

#i cant fucking do this my brain doesnt want to do shit
func _physics_process(delta: float) -> void:
	angular_velocity = 1
	TIME += delta
	if TIME > 0.1:
		DIRECTION = player.position - self.position
		linear_velocity += accel * DIRECTION.normalized()
		if linear_velocity.length() > max_speed:
			linear_velocity = Vector2(max_speed, max_speed)
		#A = (max_speed - linear_velocity.length()) * accel * DIRECTION
		#linear_velocity -= linear_velocity * friction
		#linear_velocity += A
		TIME = 0
