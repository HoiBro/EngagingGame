extends StaticBody2D

@onready var player = $"../../..".find_children("*", "CharacterBody2D", false, false)[-1]

func hit(rid, body, _body_index, _local_index):
	if body == player and player.get_rid() == rid:
		player.death()
