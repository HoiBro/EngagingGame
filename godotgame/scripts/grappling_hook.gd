extends Node2D

@export var reload_time = 1.8
@export var ready_to_fire: bool = true
@export var raycast_length = 100000
@export var result: Dictionary = {} #global dictionary for raycasting

@onready var player: CharacterBody2D = $".."

var MPOS: Vector2 = Vector2(0, 0)
var QUERY: PhysicsRayQueryParameters2D
var CAST: Dictionary = {}
signal raycast_result

func _input(event) -> void:
	if event.is_action_pressed(&"fire grappling hook") and ready_to_fire and (player.item == 1 or player.item == 2):
		MPOS = get_local_mouse_position().normalized()
		player.just_jumped = false
		player.has_grappled = false
		
		get_tree().create_timer(reload_time, false).timeout.connect(_on_reload_timer_timeout)
		
		result = {}
		QUERY = PhysicsRayQueryParameters2D.create(player.position, player.position + MPOS * raycast_length, 1, [player])
		CAST = get_world_2d().direct_space_state.intersect_ray(QUERY)
		if CAST != {}:
			#put code that looks for an objects property in the raycast here
			if CAST.collider != null:
				$"../../Polygon2D".position = CAST.position
		for i in CAST:
			result[i] = CAST[i] #update global dictionary
		raycast_result.emit()
		
		ready_to_fire = false

func _on_reload_timer_timeout() -> void:
	if player.is_grappling:
		await player.done_grappling
	ready_to_fire = true
