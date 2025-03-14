extends StaticBody2D

func hit(rid, body, _body_index, _local_index):
	if body == $"../../Player" and $"../../Player".get_rid() == rid:
		$"../../Player".death()
