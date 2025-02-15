extends RigidBody2D

@export var enemy_stats = {
	"health": 10
}
@export var accel = 500
@export var player_detection: bool = false
@export var charge_time = 1

@onready var player = $"../Player"
@onready var shotgun = $"../Player/Shotgun"
@onready var TARGET_POS = position

var TIME: float = 0
var DIRECTION

func _ready() -> void:
	if position == Vector2(1224, -7):
		queue_free()

func damage(amount: int) -> void:
	enemy_stats.health -= amount
	if enemy_stats.health <= 0:
		queue_free()

func player_detected(rid, body, body_index, local_index):
	if body == player and player.get_rid() == rid:
		player_detection = true
		print("PLAYER PLAYER WEEWOO")

func _physics_process(delta: float) -> void:
	rotation = 0
	if player_detection:
		TIME -= delta
		if (player.position - position).length() < 64:
			player.death()
		if TIME <= 0:
			TARGET_POS = player.position
			DIRECTION = player.position - self.position
			linear_velocity = Vector2(accel, accel) * DIRECTION.normalized()
			TIME = charge_time
