extends StaticBody2D

var player_pos: Vector2 = Vector2.ZERO

func _ready() -> void:
	$"Sprite2D".rotation = ($"..".position - player_pos).normalized().angle()

func _physics_process(delta: float) -> void:
	position += 1000 * (player_pos - $"..".position).normalized() * delta

func collision(body: Node2D) -> void:
	if body != $"..":
		queue_free()

func body_collision(rid, body, _body_index, _local_index) -> void:
	if body == $"../../../Player" and $"../../../Player".get_rid() == rid:
		$"../../../Player".death()
