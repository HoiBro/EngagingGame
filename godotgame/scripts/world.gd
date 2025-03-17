extends Node2D

@export var player_scene: PackedScene

@export var current_level: int

@onready var menu = $"../Menu"

var PLAYER

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"pause"):
		if not get_tree().paused:
			get_tree().paused = true
			menu.position = find_children("*", "CharacterBody2D", false, false)[0].position - 0.5*menu.size
			menu.show()
		else:
			get_tree().paused = false
			menu.hide()
	
	if event.is_action_pressed(&"respawn"):
		if find_children("*", "CharacterBody2D", false, false) != []: #remove current player
			PLAYER = find_children("*", "CharacterBody2D", false, false)[0]
			PLAYER.remove_child(PLAYER.find_child("Hitbox"))
			PLAYER.queue_free()
		find_children("*", "TileMapLayer", false, false)[0].queue_free()
		var player = player_scene.instantiate()
		add_child(player)
		var level = menu.levels[current_level].instantiate()
		add_child(level)
		get_tree().paused = false
		menu.hide()
		print("respawned")
