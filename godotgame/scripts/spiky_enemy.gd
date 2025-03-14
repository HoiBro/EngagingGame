extends RigidBody2D

@export var enemy_stats = {
	"health": 20
}

@onready var shotgun = $"../../Player/Shotgun"
@onready var player = $"../../Player"

func damage(amount: int) -> void:
	enemy_stats.health -= amount
	if enemy_stats.health <= 0:
		remove_child($Hitbox)
		queue_free()

func body_collision(rid, body, _body_index, _local_index) -> void:
	if body == player and player.get_rid() == rid:
		player.death()
