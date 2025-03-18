extends Control

@export var levels: Array[PackedScene]
@export var world_scene: PackedScene

@onready var world: Node

func _ready() -> void:
	get_tree().paused = true
	world = world_scene.instantiate()
	add_sibling.call_deferred(world)
	get_tree().create_timer(0.01).timeout.connect(world_config)

##Configurates the world directory after it has been created
func world_config():
	world = $"../World"

func returns():
	if world.find_children("*", "CharacterBody2D", false, false) != []:
		get_tree().paused = false
		hide()

func load_level(number: int):
	#Reinstantiate the correct level and player
	if world.find_children("*", "CharacterBody2D", false, false) != []:
		world.remove_child(world.find_children("*", "CharacterBody2D", false, false)[0])
	world.remove_child(world.find_children("*", "TileMapLayer", false, false)[0])
	var player = world.player_scene.instantiate()
	world.add_child(player)
	var level = levels[number-1].instantiate()
	world.add_child(level)
	world.current_level = number-1
	
	get_tree().paused = false
	hide()
