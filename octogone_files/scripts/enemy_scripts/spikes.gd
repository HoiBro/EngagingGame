extends StaticBody2D

@onready var player: Node = $"../../..".find_children("*", "CharacterBody2D", false, false)[-1]

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"respawn") and (not $"../../../../Menu/MenuLayer".visible or $"../../../../Menu/MenuLayer/WinScreen".visible):
		get_tree().create_timer(0.01).timeout.connect(respawn_check)

func hit(rid, body, _body_index, _local_index):
	if body == player and player.get_rid() == rid:
		player.death()

func respawn_check():
	player = $"../../..".find_children("*", "CharacterBody2D", false, false)[-1]
