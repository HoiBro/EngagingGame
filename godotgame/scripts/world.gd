extends Node2D

@export var player_scene: PackedScene
@export var spiky_scene: PackedScene
@export var bee_scene: PackedScene
@export var spider_scene: PackedScene
@export var spike_scene: PackedScene
@export var pause_menu: PackedScene

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"pause"):
		if not get_tree().paused:
			get_tree().paused = true
			var menu = pause_menu.instantiate()
			menu.position = get_child(-1).position
			add_sibling(menu)
	
	if event.is_action_pressed(&"respawn"):
		if get_child(-1) is not CharacterBody2D:
			get_tree().paused = false
			var player = player_scene.instantiate()
			add_child(player)
			print("respawned")
	
	if event.is_action_pressed(&"spawn_spiky"):
		var spiky = spiky_scene.instantiate()
		spiky.position = Vector2(0, 1)
		$EnemyTileSet.add_child(spiky)
		print("spawned spiky")
	
	if event.is_action_pressed(&"spawn_bee"):
		var bee = bee_scene.instantiate()
		bee.position = Vector2(0, 1)
		$EnemyTileSet.add_child(bee)
		print("spawned bee")
	
	if event.is_action_pressed(&"spawn_spider"):
		var spider = spider_scene.instantiate()
		spider.position = Vector2(0, 1)
		$EnemyTileSet.add_child(spider)
		print("spawned spider")
