extends RigidBody2D

var enemy_stats = {
	"health": 100
}

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"fire shotgun"):
		await $"../Player/Shotgun".SPACE_STATE.collider
		if $"../Player/Shotgun".SPACE_STATE.collider == RigidBody2D:
			enemy_stats.health -= 10
			if enemy_stats.health <= 0:
				get_tree().queue_delete($".")
	print(enemy_stats.health)
