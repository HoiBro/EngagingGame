extends Node2D

@export var reload_time = 1.8
@export var pull = 1000
@export var ready_to_fire: bool = true
@export var raycast_length = 1000
@export var result: Dictionary = {} # global dictionary for raycasting

@onready var player: CharacterBody2D = $".."
@onready var grappling_hook_model: Sprite2D = $"../PlayerSprite/Sprite2D/GrapplingHookSprite"

var MPOS: Vector2 = Vector2(0, 0)
var GRAPPLING_HOOK_POSITION: Vector2 = Vector2(0, 0)
var QUERY: PhysicsRayQueryParameters2D
var CAST: Dictionary = {}
signal raycast_result

func _input(event) -> void:
	if event.is_action_pressed(&"fire grappling hook") && ready_to_fire:
		MPOS = get_local_mouse_position().normalized()
		GRAPPLING_HOOK_POSITION = grappling_hook_model.position + player.position
		player.velocity += MPOS * pull
		player.just_jumped = false
		
		get_tree().create_timer(reload_time, false).timeout.connect(_on_reload_timer_timeout)
		
		result = {}
		QUERY = PhysicsRayQueryParameters2D.create(GRAPPLING_HOOK_POSITION, GRAPPLING_HOOK_POSITION + MPOS * raycast_length, 1, [player])
		CAST = get_world_2d().direct_space_state.intersect_ray(QUERY)
		for i in CAST:
			result[i] = CAST[i] # update global dictionary
		raycast_result.emit()
		
		ready_to_fire = false

func _on_reload_timer_timeout() -> void:
	ready_to_fire = true
