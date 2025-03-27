extends StaticBody2D

@export var enemy_count: int = 0

@onready var player: Node = $"../../..".find_children("*", "CharacterBody2D", false, false)[-1]

func _ready() -> void:
	get_tree().create_timer(0.01).timeout.connect(enemy_check)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"fire shotgun"):
		get_tree().create_timer(0.01).timeout.connect(enemy_check)
	if event.is_action_pressed(&"fire grappling hook"):
		get_tree().create_timer(0.01).timeout.connect(enemy_check)
	if event.is_action_pressed(&"respawn"):
		get_tree().create_timer(0.01).timeout.connect(respawn_check)

func hit(rid, body, _body_index, _local_index):
	if body == player and player.get_rid() == rid and $Open.visible:
		player.win()

##Reset player rid after respawn
func respawn_check():
	player = $"../../..".find_children("*", "CharacterBody2D", false, false)[-1]
	enemy_count = $"../../EnemyTileset".find_children("*", "", false, false).size()
	$EnemyCounter.text = str(enemy_count)
	$Closed.show()
	$EnemyCounter.show()
	$Open.hide()

##Check the amount of enemies left in the level
func enemy_check():
	enemy_count = $"../../EnemyTileset".find_children("*", "", false, false).size()
	$EnemyCounter.text = str(enemy_count)
	if enemy_count == 0:
		$Closed.hide()
		$EnemyCounter.hide()
		$Open.show()
