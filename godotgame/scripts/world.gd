extends Node2D

@export var enemy_scene: PackedScene
@export var bee_scene: PackedScene
@export var spider_scene: PackedScene
@export var spike_scene: PackedScene

var spike_positions = [
	[9500, -1200]
]

func _ready() -> void:
	for i in range(len(spike_positions)):
		var spike = spike_scene.instantiate()
		spike.position = Vector2(spike_positions[i][0], spike_positions[i][1])
		add_child(spike)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"spawn_spider"):
		var spider = spider_scene.instantiate()
		spider.position = Vector2(12000, -1500)
		add_child(spider)
		print("spawned spider")
	if event.is_action_pressed(&"spawn_bee"):
		var bee = bee_scene.instantiate()
		bee.position = Vector2(10000, -1500)
		add_child(bee)
		print("spawned bee")
	if event.is_action_pressed(&"spawn_enemy"):
		var enemy = enemy_scene.instantiate()
		enemy.position = Vector2(randf_range(-1000, 1000), randf_range(-1000, 1000))
		add_child(enemy)
		print("spawned enemy")

func swap_tilemap(event: InputEvent) -> void:
	if event.is_action_pressed(&"swap_tilemap"):
		if get_child(2).hidden:
			get_child(1).hide()
			get_child(2).show()
		
		if get_child(1).hidden:
			get_child(2).hide()
			get_child(1).show()
