extends Control

@export var levels: Array[PackedScene]
@export var medal_times: Dictionary = {
	"level_shotgun": [30, 20, 16, 10, 8.5],
	"level_grappling": [30, 20, 15, 12, 8],
	"level_zigzag": [45, 35, 20, 15, 12],
	"level_buzz": [45, 35, 25, 16, 13],
	"level_spiderswing": [45, 30, 18, 14, 10],
	"level_backtrack": [50, 40, 30, 22.5, 12],
	"level_slide": [40, 30, 20, 15, 12],
	"level_beetower": [60, 40, 25, 15, 8],
	"level_turbine": [60, 30, 21, 14, 8],
	"level_escape": [45, 30, 20, 15, 12],
	"level_maze": [300, 120, 60, 50, 40],
	"level_needle": [0, 0, 0, 0, 99999]
}
@export var level_indexes: Dictionary = {
	"level_shotgun": 1,
	"level_grappling": 2,
	"level_zigzag": 3,
	"level_buzz": 4,
	"level_spiderswing": 5,
	"level_backtrack": 6,
	"level_slide": 7,
	"level_beetower": 8,
	"level_turbine": 9,
	"level_escape": 10,
	"level_maze": 11,
	"level_needle": 12
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
	load("res://textures/menu_sprites/medals/empty.png"),
	load("res://textures/menu_sprites/medals/bronze.png"),
	load("res://textures/menu_sprites/medals/silver.png"),
	load("res://textures/menu_sprites/medals/gold.png"),
	load("res://textures/menu_sprites/medals/diamond.png"),
	load("res://textures/menu_sprites/medals/ruby.png")
]

var REBINDING: bool = false
var INPUT_REBIND: String = ""
var PREVIOUS_SCREEN

var OLD_PLAYER: Array = []
var OLD_TILEMAP: Node2D
var NEW_PLAYER: Node2D
var NEW_LEVEL: Node2D

var RECORD: float = 0
var MEDAL: int = 0
var LEVEL_INDEX: int = 0
var LEVEL_BUTTON: Node

var MSEC: int = 0
var SEC: float = 0
var MIN: float = 0
var FORMAT_STR: String = "%02d : %02d . %02d"
var ACT_STR: String = ""

func _ready() -> void:
	get_tree().paused = true
	if not SaveSystem.has("progress"):
		SaveSystem.set_var("progress", 1)
		SaveSystem.save()
	update_level_select()
	world = world_scene.instantiate()
	add_sibling.call_deferred(world)
	get_tree().create_timer(0.01).timeout.connect(world_config)

func _input(event: InputEvent) -> void:
	if REBINDING:
		if event is not InputEventMouseMotion:
			InputMap.action_add_event("%s" % INPUT_REBIND, event)
			$"MenuLayer/Options/Controls".show()
			$"MenuLayer/Options/RebindScreen".hide()
			REBINDING = false

##Configurates the world directory after it has been created
func world_config() -> void:
	world = $"../World"

##Continue the run
func returns() -> void:
	if world.find_children("*", "CharacterBody2D", false, false) != []:
		get_tree().paused = false
		$MenuLayer.hide()

func quit() -> void:
	get_tree().quit(0)

##Show a specific options screen
##node goes from the Options node
func options_show(node: String) -> void:
	if node != "Audio":
		$"MenuLayer/Options/Audio".hide()
	else:
		$"MenuLayer/Options/Audio".show()
	if node != "Controls":
		$"MenuLayer/Options/Controls".hide()
	else:
		$"MenuLayer/Options/Controls".show()
	if node != "Credits":
		$"MenuLayer/Options/Credits".hide()
	else:
		$"MenuLayer/Options/Credits".show()

func rebind(binding: String) -> void:
	InputMap.action_erase_events(binding)
	INPUT_REBIND = binding
	$"MenuLayer/Options/Controls".hide()
	$"MenuLayer/Options/RebindScreen".show()
	REBINDING = true

##Load a level using a provided number
func load_level(number: int) -> void:
	if SaveSystem.get_var("progress") < number:
		return
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
	if number == 7:
		NEW_PLAYER.position += Vector2(0, -15488)
	NEW_LEVEL = levels[number-1].instantiate()
	world.add_child(NEW_LEVEL)
	world.current_level = number-1
	
	get_tree().paused = false
	$MenuLayer.hide()
	$"../World/DeathScreen".hide()

##Function to show a specific menu screen,
##NodePath needs to go from the Menu node
func show_single_screen(node_path: NodePath) -> void:
	for node in $MenuLayer.get_children():
		if node.visible and node != $"MenuLayer/BackgroundBlur":
			PREVIOUS_SCREEN = self.get_path_to(node)
		node.hide()
	get_node(node_path).show()
	$"MenuLayer/BackgroundBlur".show()

func back() -> void:
	show_single_screen(PREVIOUS_SCREEN)

##Updates the level select with the current best times in the save data
func update_level_select() -> void:
	for level in SaveSystem.current_state_dictionary:
		if level == "progress":
			continue
		RECORD = SaveSystem.get_var("%s:record" % level)
		MEDAL = SaveSystem.get_var("%s:medal" % level)
		LEVEL_INDEX = level_indexes.get(level)
		if LEVEL_INDEX <= 10:
			LEVEL_BUTTON = $"MenuLayer/LevelSelectLab".get_child(LEVEL_INDEX - 1)
		else:
			LEVEL_BUTTON = $"MenuLayer/LevelSelectLabBonus".get_child(LEVEL_INDEX - 11)
		LEVEL_BUTTON.get_child(1).text = record_to_string(RECORD)
		LEVEL_BUTTON.get_child(2).texture = medal_sprites[MEDAL]

##Show the win screen with updated times and medal
func win_screen(level_name: String) -> void:
	update_level_select()
	RECORD = SaveSystem.get_var("%s:record" % level_name)
	MEDAL = SaveSystem.get_var("%s:medal" % level_name)
	$"MenuLayer/WinScreen/RecordLabel".text = record_to_string(RECORD)
	$"MenuLayer/WinScreen/MedalLabel".text = medals[MEDAL]
	$"MenuLayer/WinScreen/MedalSprite".texture = medal_sprites[MEDAL]
	show_single_screen("MenuLayer/WinScreen")

##Convert a record into a string of the format "00 : 00 . 000"
func record_to_string(record: float) -> String:
	SEC = floor(fmod(record, 60))
	MSEC = round((record - floor(record))*1000)
	MIN = record / 60
	ACT_STR = FORMAT_STR % [MIN, SEC, MSEC]
	if MSEC < 100:
		ACT_STR = ACT_STR.insert(10, "0")
	return ACT_STR
