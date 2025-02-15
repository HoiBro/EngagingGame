extends Node2D

@export var reload_time = 1.8
@export var recoil = 1500
@export var ready_to_fire: bool = true
@export var raycast_length = 1000

@onready var player: CharacterBody2D = $".."
@onready var shotgun_sprite: Sprite2D = $"../PlayerSprite/ShotgunSprite"

var MPOS: Vector2 = Vector2(0, 0)
var v_relative = Vector2(0,0)
var angle
var bounce = 0.1
var QUERY: PhysicsRayQueryParameters2D
var CAST: Dictionary = {}

func _input(event) -> void:
	if event.is_action_pressed(&"fire shotgun") and ready_to_fire:
		MPOS = get_local_mouse_position().normalized()
		angle = MPOS.angle_to(Vector2(0,-1))
		v_relative = player.velocity.rotated(angle)
		if v_relative.y < 0:
			player.velocity = Vector2(v_relative.x,-bounce*v_relative.y).rotated(-angle) - MPOS * recoil
		else:
			player.velocity += -MPOS * recoil
		
		player.just_jumped = false
		player.HAS_JUMPED = true
		
		get_tree().create_timer(reload_time, false).timeout.connect(_on_reload_timer_timeout)
		
		$AudioStreamPlayer.play()
		
		QUERY = PhysicsRayQueryParameters2D.create(player.position, player.position + MPOS * raycast_length, 1, [player])
		CAST = get_world_2d().direct_space_state.intersect_ray(QUERY)
		if CAST != {} and CAST.collider != null and CAST.collider.get_class() == "RigidBody2D":
			if get_node(CAST.collider.get_path()).has_method("damage"): #Check whether the node can be damaged
				get_node(CAST.collider.get_path()).damage(10)
		
		ready_to_fire = false

func _on_reload_timer_timeout() -> void:
	ready_to_fire = true
