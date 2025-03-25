extends Node2D

@export var player_scene: PackedScene

@export var current_level: int = 0

@onready var menu: Node = $"../Menu"

var LEVEL: Node

func _ready() -> void:
	$Soundtrack.play()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"pause"):
		if not get_tree().paused:
			get_tree().paused = true
			menu.position = find_children("*", "CharacterBody2D", false, false)[0].position - 0.5*menu.size
			menu.scale = Vector2((1/$"Player/PlayerCamera".zoom.x)*201/200, (1/$"Player/PlayerCamera".zoom.x)*201/200)
			menu.show()
		elif find_children("*", "CharacterBody2D", false, false) != []:
			get_tree().paused = false
			menu.hide()
	
	if event.is_action_pressed(&"respawn"):
		var old_player = find_children("*", "CharacterBody2D", false, false)
		if old_player != []: #remove current player
			remove_child(old_player[0])
			old_player[0].queue_free()
		else:
			$DeathScreen.hide()
		LEVEL = find_children("*", "TileMapLayer", false, false)[0]
		var old_tilemap = LEVEL.get_child(-1)
		LEVEL.remove_child(old_tilemap)
		old_tilemap.queue_free()
		
		var player = player_scene.instantiate()
		add_child(player)
		var level = menu.levels[current_level].instantiate()
		var etileset = level.get_child(-1)
		level.remove_child(etileset)
		LEVEL.add_child(etileset)
		level.queue_free()
		
		get_tree().paused = false
		menu.hide()
		print("respawned")
