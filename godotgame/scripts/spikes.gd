extends StaticBody2D

@onready var player = $"../..".get_child(-1)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"respawn"):
		if $"../..".get_child(-1) is not CharacterBody2D:
			get_tree().create_timer(0.01).timeout.connect(respawn_check)

func hit(rid, body, _body_index, _local_index):
	if body == player and player.get_rid() == rid:
		player.death()

func respawn_check():
	player = $"../..".get_child(-1)
