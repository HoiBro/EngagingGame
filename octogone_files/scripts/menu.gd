extends Control

@export var levels: Array[PackedScene]
@export var medal_times: Dictionary = {
	"level_shotgun": [30, 20, 15, 10, 8.5],
	"level_grappling": [30, 20, 15, 10, 8],
	"level_zigzag": [40, 30, 20, 15, 12],
	"level_buzz": [40, 30, 20, 15, 13],
	"level_spiderswing": [45, 30, 20, 13, 10],
	"level_backtrack": [50, 40, 30, 22.5, 12],
	"level_beetower": [60, 40, 25, 15, 8],
	"level_turbine": [60, 45, 30, 15, 8],
	"level_escape": [45, 30, 20, 15, 12],
	"level_maze": [300, 120, 60, 50, 40],
	"level_needle": [0, 0, 0, 0, 99999]
}
@export var world_scene: PackedScene

var world: Node
var medals: Array = [
	"None",
	"Bronze",
	"Silver",
	"Gold",
	"Diamond",
	"Ruby"
]
var medal_sprites: Array = [
	0,
	load("res://textures/menu_sprites/bronze.png"),
	load("res://textures/menu_sprites/silver.png"),
	load("res://textures/menu_sprites/gold.png"),
	load("res://textures/menu_sprites/diamond.png"),
	load("res://textures/menu_sprites/ruby.png")
]

var OLD_PLAYER: Array = []
var OLD_TILEMAP: Node2D
var NEW_PLAYER: Node2D
var NEW_LEVEL: Node2D

var RECORD: float = 0
var MEDAL: int = 0

var MSEC: int = 0
var SEC: float = 0
var MIN: float = 0
var FORMAT_STR: String = "%02d : %02d . %02d"
var ACT_STR: String = ""

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
	$"../World/DeathScreen".hide()

##Function to show a specific menu screen,
##NodePath needs to go from the Menu node
func show_single_screen(node_path: NodePath):
	for node in $MenuLayer.get_children():
		node.hide()
	get_node(node_path).show()
	$"MenuLayer/BackgroundBlur".show()

##Show the win screen with updated times and medal
func win_screen(level_name: String):
	RECORD = SaveSystem.get_var("%s:record" % level_name)
	MEDAL = SaveSystem.get_var("%s:medal" % level_name)
	$"MenuLayer/WinScreen/RecordLabel".text = record_to_string(RECORD)
	$"MenuLayer/WinScreen/MedalLabel".text = medals[MEDAL]
	$"MenuLayer/WinScreen/MedalSprite".texture = medal_sprites[MEDAL]
	show_single_screen("MenuLayer/WinScreen")

##Convert a record into a string of the format "00 : 00 . 000"
func record_to_string(record: float) -> String:
	SEC = fmod(record, 60)
	MSEC = round((record - SEC)*1000)
	MIN = record / 60
	ACT_STR = FORMAT_STR % [MIN, SEC, MSEC]
	if MSEC < 100:
		ACT_STR = ACT_STR.insert(10, "0")
	return ACT_STR
