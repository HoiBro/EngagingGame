extends StaticBody2D

var player_pos: Vector2 = Vector2.ZERO

@onready var player = $"../../../..".find_children("*", "CharacterBody2D", false, false)[-1]

func _physics_process(delta: float) -> void:
	position += 1000 * (player_pos - $"..".global_position).normalized() * delta

func collision(body: Node2D) -> void:
	if body != $"..":
		queue_free()

func body_collision(rid, body, _body_index, _local_index) -> void:
	if body == player and player.get_rid() == rid:
		player.death()
