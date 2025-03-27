extends RigidBody2D

@export var enemy_stats: Dictionary = {
	"health": 10
}
@export var accel: int = 750
@export var charge_time: float = 1

@onready var player: Node = $"../../..".find_children("*", "CharacterBody2D", false, false)[-1]

var MOVING: bool = false
var DIRECTION: Vector2 = Vector2.ZERO
var HITBOX: Node2D

func _ready() -> void:
	player.died.connect(player_death)

func damage(amount: int) -> void:
	enemy_stats.health -= amount
	if enemy_stats.health <= 0:
		HITBOX = $Hitbox
		remove_child(HITBOX)
		HITBOX.queue_free()
		$"../../../BeeDeath".play()
		queue_free()
		return
	$"../../../EnemyHit".play()

func player_detected(rid, body, _body_index, _local_index):
	if body == player and player.get_rid() == rid:
		if not MOVING:
			MOVING = true
			movement_start()

func movement_start() -> void:
	if MOVING:
		DIRECTION = (player.position - global_position).normalized()
		linear_velocity = Vector2(accel, accel) * DIRECTION
		set_rotation(-DIRECTION.angle_to(Vector2.UP))
		angular_velocity = 0
		get_tree().create_timer(charge_time, false).timeout.connect(movement_start)

func body_collision(rid, body, _body_index, _local_index) -> void:
	if body == player and player.get_rid() == rid:
		player.death()

func player_death():
	MOVING = false
	linear_velocity = Vector2.ZERO
