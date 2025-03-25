extends RigidBody2D

@export var enemy_stats: Dictionary = {
	"health": 20
}

@onready var player: Node = $"../../..".find_children("*", "CharacterBody2D", false, false)[-1]

var HITBOX: Node2D

func damage(amount: int) -> void:
	enemy_stats.health -= amount
	if enemy_stats.health <= 0:
		HITBOX = $Hitbox
		remove_child(HITBOX)
		HITBOX.queue_free()
		$"../../../SpikyDeath".play()
		queue_free()
		return
	$"../../../EnemyHit".play()

func body_collision(rid, body, _body_index, _local_index) -> void:
	if body == player and player.get_rid() == rid:
		player.death()
