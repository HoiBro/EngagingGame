extends RigidBody2D

@export var enemy_stats = {
	"health": 20
}

@onready var player = $"../..".get_child(-1)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"respawn"):
		if $"../..".get_child(-1) is not CharacterBody2D:
			get_tree().create_timer(0.01).timeout.connect(respawn_check)

func damage(amount: int) -> void:
	enemy_stats.health -= amount
	if enemy_stats.health <= 0:
		remove_child($Hitbox)
		queue_free()

func body_collision(rid, body, _body_index, _local_index) -> void:
	if body == player and player.get_rid() == rid:
		player.death()

func respawn_check():
	player = $"../..".get_child(-1)
