extends Node2D

@export var player_scene: PackedScene

@export var current_level: int = 0

@onready var menu: Node = $"../Menu"
@onready var menu_layer: Node = $"../Menu/MenuLayer"

var OLD_PLAYER: Array = []
var OLD_LEVEL: Node2D
var OLD_TILEMAP: Node2D
var NEW_PLAYER: Node2D
var NEW_LEVEL: Node2D
var ETILESET: Node2D

func _ready() -> void:
	$Soundtrack.play()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"pause"):
		if not get_tree().paused:
			get_tree().paused = true
			menu_layer.show()
		elif $DeathScreen.visible:
			menu_layer.visible = !menu_layer.visible
		elif find_children("*", "CharacterBody2D", false, false) != []:
			get_tree().paused = false
			menu_layer.hide()
	
	if event.is_action_pressed(&"respawn"):
		OLD_PLAYER = find_children("*", "CharacterBody2D", false, false)
		if OLD_PLAYER != []: #remove current player
			remove_child(OLD_PLAYER[0])
			OLD_PLAYER[0].queue_free()
		else:
			$DeathScreen.hide()
		OLD_LEVEL = find_children("*", "TileMapLayer", false, false)[0]
		OLD_TILEMAP = OLD_LEVEL.get_child(-1)
		OLD_LEVEL.remove_child(OLD_TILEMAP)
		OLD_TILEMAP.queue_free()
		
		NEW_PLAYER = player_scene.instantiate()
		add_child(NEW_PLAYER)
		NEW_LEVEL = menu.levels[current_level].instantiate()
		ETILESET = NEW_LEVEL.get_child(-1)
		NEW_LEVEL.remove_child(ETILESET)
		OLD_LEVEL.add_child(ETILESET)
		NEW_LEVEL.queue_free()
		
		get_tree().paused = false
		menu_layer.hide()
