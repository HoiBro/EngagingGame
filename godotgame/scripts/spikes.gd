extends StaticBody2D


func _ready() -> void:
	if position == Vector2.ZERO:
		queue_free()

func hit(rid, body, _body_index, _local_index):
	if body == $"../Player" and $"../Player".get_rid() == rid:
		$"../Player".death()
