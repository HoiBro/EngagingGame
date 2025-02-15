extends RigidBody2D

@export var enemy_stats = {
	"health": 20
}

@onready var shotgun = $"../Player/Shotgun"

func damage(amount: int) -> void:
	enemy_stats.health -= amount
	if enemy_stats.health <= 0:
		queue_free()
