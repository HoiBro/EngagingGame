extends RigidBody2D

@export var enemy_stats = {
	"health": 100
}

@onready var shotgun = $"../Player/Shotgun"

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"fire shotgun"):
		await shotgun.raycast_result
		if shotgun.result != {}:
			if shotgun.result.collider.get_class() == "RigidBody2D":
				enemy_stats.health -= 10
			if enemy_stats.health <= 0:
				get_tree().queue_delete($".")
		print(enemy_stats.health)
