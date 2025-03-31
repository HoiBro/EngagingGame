extends Control

@export var levels: Array[PackedScene]
@export var medal_times: Dictionary = {
	"level_shotgun": [30, 20, 15, 10, 8.5],
	"level_grappling": [30, 20, 15, 10, 8],
	"level_zigzag": [40, 30, 20, 15, 12],
	"level_buzz": [40, 30, 20, 15, 13],
	"level_spiderswing": [45, 30, 20, 13, 10],
	"level_beetower": [60, 40, 25, 15, 8],
	"level_escape": [45, 30, 20, 15, 12],
	"level_maze": [300, 120, 60, 50, 40]
}
@export var world_scene: PackedScene

var world: Node

var OLD_PLAYER: Array = []
var OLD_TILEMAP: Node2D
var NEW_PLAYER: Node2D
var NEW_LEVEL: Node2D

func _ready() -> void:
	get_tree().paused = true
	world = world_scene.instantiate()
	add_sibling.call_deferred(world)
	get_tree().create_timer(0.01).timeout.connect(world_config)

##Configurates the world directory after it has been created
func world_config():
	world = $"../World"

##Continue the run
func returns():
	if world.find_children("*", "CharacterBody2D", false, false) != []:
		get_tree().paused = false
		$MenuLayer.hide()

##Load a level using a provided number
func load_level(number: int):
	#Reinstantiate the correct level and player
	OLD_PLAYER = world.find_children("*", "CharacterBody2D", false, false)
	if OLD_PLAYER != []: #remove current player
		world.remove_child(OLD_PLAYER[0])
		OLD_PLAYER[0].queue_free()
	OLD_TILEMAP = world.find_children("*", "TileMapLayer", false, false)[0]
	world.remove_child(OLD_TILEMAP)
	OLD_TILEMAP.queue_free()
	
	NEW_PLAYER = world.player_scene.instantiate()
	world.add_child(NEW_PLAYER)
	NEW_LEVEL = levels[number-1].instantiate()
	world.add_child(NEW_LEVEL)
	world.current_level = number-1
	
	get_tree().paused = false
	$MenuLayer.hide()
