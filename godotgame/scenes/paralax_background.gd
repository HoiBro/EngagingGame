extends Sprite2D
@onready var camera = $"../Player/PlayerCamera"
@onready var player = $"../Player"

func _process(delta: float) -> void:
	position.x = camera.position.x + player.global_position.x
