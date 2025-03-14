extends RigidBody2D

@export var enemy_stats = {
	"health": 10
}
@export var accel = 500
@export var charge_time = 1

@onready var player = $"../../Player"
@onready var shotgun = $"../../Player/Shotgun"

var TARGET_POS: Vector2 = Vector2.ZERO
var DIRECTION: Vector2 = Vector2.ZERO

func damage(amount: int) -> void:
	enemy_stats.health -= amount
	if enemy_stats.health <= 0:
		remove_child($Hitbox)
		queue_free()

func player_detected(rid, body, _body_index, _local_index):
	if body == player and player.get_rid() == rid:
		movement_start()
		$"DetectionArea".queue_free()

func movement_start() -> void:
	TARGET_POS = player.position
	DIRECTION = player.position - self.position
	linear_velocity = Vector2(accel, accel) * DIRECTION.normalized()
	get_tree().create_timer(charge_time, false).timeout.connect(movement_start)

func body_collision(rid, body, _body_index, _local_index) -> void:
	if body == player and player.get_rid() == rid:
		player.death()
