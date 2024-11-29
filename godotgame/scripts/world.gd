extends Node2D

@export var enemy_scene: PackedScene

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"spawn_enemy"):
		var enemy = enemy_scene.instantiate()
		enemy.position = Vector2(randf_range(-1000, 1000), randf_range(-1000, 1000))
		add_child(enemy)
		print("spawned enemy")
