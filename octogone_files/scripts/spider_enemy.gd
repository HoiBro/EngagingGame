extends RigidBody2D

@export var enemy_stats: Dictionary = {
	"health": 40
}
@export var shoot_time: float = 1
@export var projectile_scene: PackedScene

@onready var player: Node = $"../../..".find_children("*", "CharacterBody2D", false, false)[-1]

var SHOOTING: bool = false
var QUERY: PhysicsRayQueryParameters2D
var CAST: Dictionary = {}
var HITBOX: Node2D

func _ready() -> void:
	$Projectile.queue_free()
	player.died.connect(player_death)
	get_tree().create_timer(0.01, false).timeout.connect(string_spawn)

func damage(amount: int) -> void:
	enemy_stats.health -= amount
	if enemy_stats.health <= 0:
		HITBOX = $Hitbox
		remove_child(HITBOX)
		HITBOX.queue_free()
		$"../../../SpiderDeath".play()
		queue_free()
		return
	$"../../../EnemyHit".play()

func player_detected(rid, body, _body_index, _local_index):
	if body == player and player.get_rid() == rid:
		if not SHOOTING:
			SHOOTING = true
			shoot()

func shoot():
	if SHOOTING:
		var projectile = projectile_scene.instantiate()
		projectile.player_pos = player.position
		call_deferred("add_child", projectile)
		$Shoot.play()
		get_tree().create_timer(shoot_time, false).timeout.connect(shoot)

func body_collision(rid, body, _body_index, _local_index) -> void:
	if body == player and player.get_rid() == rid:
		player.death()

func string_spawn():
	QUERY = PhysicsRayQueryParameters2D.create(position, position + Vector2.UP * 10000, 1, [self])
	CAST = get_world_2d().direct_space_state.intersect_ray(QUERY)
	if CAST != {}:
		$"String".add_point(CAST.position - position)

func player_death():
	SHOOTING = false
