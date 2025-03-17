extends Control

@export var levels: Array[PackedScene]
@export var world_scene: PackedScene

@onready var world

func _ready() -> void:
	get_tree().paused = true
	world = world_scene.instantiate()
	add_sibling.call_deferred(world)
	get_tree().create_timer(0.1).timeout.connect(world_config)

##Configurates the world directory after it has been created
func world_config():
	world = $"../World"

func returns():
	get_tree().paused = false
	hide()

func load_level(number: int):
	world.remove_child(world.find_children("*", "TileMapLayer", false, false)[0])
	var level = levels[number-1].instantiate()
	world.add_child(level)
	world.current_level = number-1
