extends StaticBody2D

var player_pos: Vector2 = Vector2.ZERO

@onready var player = $"../../..".get_child(-1)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"respawn"):
		if $"../..".get_child(-1) is not CharacterBody2D:
			get_tree().create_timer(0.01, false).timeout.connect(respawn_check)

func _physics_process(delta: float) -> void:
	position += 1000 * (player_pos - $"..".position).normalized() * delta

func collision(body: Node2D) -> void:
	if body != $"..":
		queue_free()

func body_collision(rid, body, _body_index, _local_index) -> void:
	if body == player and player.get_rid() == rid:
		player.death()

func respawn_check():
	player = $"../../..".get_child(-1)
