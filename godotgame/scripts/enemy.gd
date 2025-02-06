extends RigidBody2D

@export var enemy_stats = {
	"health": 20
}

@onready var shotgun = $"../Player/Shotgun"

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"fire shotgun"):
		await shotgun.raycast_result
		if (shotgun.result != {} and shotgun.result.collider != null and 
			shotgun.result.collider.get_class() == "RigidBody2D" and shotgun.result.rid == get_rid()):
				enemy_stats.health -= 10
		if enemy_stats.health <= 0:
			queue_free()
		#print(enemy_stats.health, position)
