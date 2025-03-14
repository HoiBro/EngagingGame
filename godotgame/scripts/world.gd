extends Node2D

@export var spiky_scene: PackedScene
@export var bee_scene: PackedScene
@export var spider_scene: PackedScene
@export var spike_scene: PackedScene

var spiky_positions = [
	
]
var bee_positions = [
	
]
var spider_positions = [
	
]
var spike_positions = [
	
]

func _ready() -> void:
	for i in range(len(spiky_positions)):
		var spiky = spiky_scene.instantiate()
		spiky.position = Vector2(spiky_positions[i][0], spiky_positions[i][1])
		add_child(spiky)
	
	for i in range(len(bee_positions)):
		var bee = bee_scene.instantiate()
		bee.position = Vector2(bee_positions[i][0], bee_positions[i][1])
		add_child(bee)
	
	for i in range(len(spider_positions)):
		var spider = spider_scene.instantiate()
		spider.position = Vector2(spider_positions[i][0], spider_positions[i][1])
		add_child(spider)
	
	#for i in range(10):
		#var spider = spider_scene.instantiate()
		#spider.position = Vector2(12000 + 10*i, -1500)
		#add_child(spider)
	
	for i in range(len(spike_positions)):
		var spike = spike_scene.instantiate()
		spike.position = Vector2(spike_positions[i][0], spike_positions[i][1])
		add_child(spike)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"spawn_spiky"):
		var spiky = spiky_scene.instantiate()
		spiky.position = Vector2(0, 1)
		add_child(spiky)
		print("spawned spiky")
	
	if event.is_action_pressed(&"spawn_bee"):
		var bee = bee_scene.instantiate()
		bee.position = Vector2(0, 1)
		add_child(bee)
		print("spawned bee")
	
	if event.is_action_pressed(&"spawn_spider"):
		var spider = spider_scene.instantiate()
		spider.position = Vector2(0, 1)
		add_child(spider)
		print("spawned spider")
