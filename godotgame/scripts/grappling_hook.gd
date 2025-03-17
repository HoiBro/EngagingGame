extends Node2D

@export var reload_time = 1.5 #Make sure this is longer than grappling_time in player script
@export var ready_to_fire: bool = true
@export var raycast_length = 10000
@export var result: Dictionary = {} #global dictionary for raycasting

@onready var player: CharacterBody2D = $".."
@onready var shotgun_sprite: Sprite2D = $"../PlayerSprite/ShotgunSprite"
@onready var graphook_sprite: Sprite2D = $"../PlayerSprite/Grapplinghook"
@onready var grap_sprite: Sprite2D = $"../PlayerSprite/Grappling"
@onready var hook_sprite: Sprite2D = $"../PlayerSprite/Hook"

var MPOS: Vector2 = Vector2.ZERO
var GRAP_POS: Vector2 = Vector2.ZERO
var QUERY: PhysicsRayQueryParameters2D
var CAST: Dictionary = {}

func _input(event) -> void:
	if event.is_action_pressed(&"fire grappling hook") and ready_to_fire and !player.has_grappled:
		MPOS = get_local_mouse_position().normalized()
		if MPOS.x <= 0:
			GRAP_POS = player.position - graphook_sprite.position
		else:
			GRAP_POS = player.position + graphook_sprite.position
		player.just_jumped = false
		
		result = {}
		QUERY = PhysicsRayQueryParameters2D.create(GRAP_POS, GRAP_POS + MPOS * raycast_length, 1, [player])
		CAST = get_world_2d().direct_space_state.intersect_ray(QUERY)
		if CAST != {}: #put code that looks for an objects property in the raycast here
			if CAST.collider != null:
				grap_sprite.show()
				graphook_sprite.hide()
				shotgun_sprite.hide()
				hook_sprite.position = CAST.position
				hook_sprite.rotation = PI-MPOS.angle_to(Vector2(-1, 0))
				hook_sprite.show()
				
				$GrapplingHook.play()
				player.is_grappling = true
				ready_to_fire = false
				get_tree().create_timer(reload_time, false).timeout.connect(_on_reload_timer_timeout)
				if CAST.collider is RigidBody2D:
					if get_node(CAST.collider.get_path()).has_method("damage"): #Check whether the node can be damaged
						get_node(CAST.collider.get_path()).damage(30)
		for i in CAST:
			result[i] = CAST[i] #update global dictionary

func _on_reload_timer_timeout() -> void:
	if grap_sprite.visible:
		graphook_sprite.show()
		grap_sprite.hide()
	hook_sprite.hide()
	ready_to_fire = true
