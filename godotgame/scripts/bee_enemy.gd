extends RigidBody2D

@export var enemy_stats = {
	"health": 20
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

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"fire shotgun"):
		await shotgun.raycast_result
		if (shotgun.result != {} and shotgun.result.collider != null and 
			shotgun.result.collider.get_class() == "RigidBody2D" and shotgun.result.rid == get_rid()):
				enemy_stats.health -= 10
		if enemy_stats.health <= 0:
			queue_free()
		#print(enemy_stats.health, position)

func player_detected(rid, body, body_index, local_index):
	if body == player and player.get_rid() == rid:
		player_detection = true
		print("PLAYER PLAYER WEEWOO")

func _physics_process(delta: float) -> void:
	rotation = 0
	if player_detection:
		TIME -= delta
		if (player.position - position).length() < 64:
			player.die()
		if TIME <= 0:
			TARGET_POS = player.position
			DIRECTION = player.position - self.position
			linear_velocity = Vector2(accel, accel) * DIRECTION.normalized()
			TIME = charge_time
