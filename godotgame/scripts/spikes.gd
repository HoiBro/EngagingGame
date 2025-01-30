extends RigidBody2D


func hit(rid, body, body_index, local_index):
	print("hit")
	if body == $"../Player" and $"../Player".get_rid() == rid:
		$"../Player".die()
