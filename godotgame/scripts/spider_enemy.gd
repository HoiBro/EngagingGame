extends RigidBody2D

@export var enemy_stats = {
	"health": 20
}
@export var player_detection: bool = false
@export var shoot_time = 1
@export var projectile_scene: PackedScene

@onready var player = $"../Player"
@onready var shotgun = $"../Player/Shotgun"

var QUERY: PhysicsRayQueryParameters2D
var CAST: Dictionary = {}

var TIMER: float = 0

func _ready() -> void:
	if position == Vector2.ZERO:
		queue_free()
	$"Projectile".queue_free()
	QUERY = PhysicsRayQueryParameters2D.create(position, position + Vector2.UP * 10000, 1, [self])
	CAST = get_world_2d().direct_space_state.intersect_ray(QUERY)
	if CAST != {}:
		$"String".add_point(CAST.position - position)

func damage(amount: int) -> void:
	enemy_stats.health -= amount
	if enemy_stats.health <= 0:
		queue_free()

func player_detected(rid, body, _body_index, _local_index):
	if body == player and player.get_rid() == rid:
		player_detection = true
		print("PLAYER PLAYER WEEWOO")

func shoot():
	var projectile = projectile_scene.instantiate()
	projectile.player_pos = $"../Player".position
	add_child(projectile)

func _physics_process(delta: float) -> void:
	rotation = 0
	if player_detection:
		TIMER -= delta
		if (player.position - position).length() < 64:
			player.death()
		if TIMER <= 0:
			shoot()
			TIMER = shoot_time

func body_collision(rid, body, _body_index, _local_index) -> void:
	if body == player and player.get_rid() == rid:
		player.death()
