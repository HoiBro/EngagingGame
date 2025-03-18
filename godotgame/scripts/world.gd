extends Node2D

@export var player_scene: PackedScene

@export var current_level: int = 0

@onready var menu: Node = $"../Menu"

var LEVEL: Node

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"pause"):
		if not get_tree().paused:
			get_tree().paused = true
			menu.position = find_children("*", "CharacterBody2D", false, false)[0].position - 0.5*menu.size
			menu.show()
		elif find_children("*", "CharacterBody2D", false, false) != []:
			get_tree().paused = false
			menu.hide()
	
	if event.is_action_pressed(&"respawn"):
		if find_children("*", "CharacterBody2D", false, false) != []: #remove current player
			remove_child(find_children("*", "CharacterBody2D", false, false)[0])
		LEVEL = find_children("*", "TileMapLayer", false, false)[0]
		LEVEL.remove_child(LEVEL.get_child(-1))
		var player = player_scene.instantiate()
		add_child(player)
		var level = menu.levels[current_level].instantiate()
		var etileset = level.get_child(-1)
		level.remove_child(etileset)
		LEVEL.add_child(etileset)
		
		get_tree().paused = false
		menu.hide()
		print("respawned")
