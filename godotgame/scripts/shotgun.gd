extends Node2D

@export var reload_time = 1.8
@export var recoil = 1500
@export var ready_to_fire: bool = true
@export var raycast_length = 1000
@export var result: Dictionary = {} #global dictionary for raycasting

@onready var player: CharacterBody2D = $".."
@onready var shotgun_sprite: Sprite2D = $"../PlayerSprite/ShotgunSprite"

var MPOS: Vector2 = Vector2(0, 0)
var v_relative = Vector2(0,0)
var angle
var bounce = 0.1
var QUERY: PhysicsRayQueryParameters2D
var CAST: Dictionary = {}
signal raycast_result

func _input(event) -> void:
	if event.is_action_pressed(&"switch_item"):
		await player.switched_item
		if player.item == 0 or player.item == 2:
			shotgun_sprite.show()
		else:
			shotgun_sprite.hide()
	if event.is_action_pressed(&"fire shotgun") and ready_to_fire and (player.item == 0 or player.item == 2):
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
		
		result = {}
		QUERY = PhysicsRayQueryParameters2D.create(player.position, player.position + MPOS * raycast_length, 1, [player])
		CAST = get_world_2d().direct_space_state.intersect_ray(QUERY)
		for i in CAST:
			result[i] = CAST[i] #update global dictionary
		raycast_result.emit()
		
		ready_to_fire = false

func _on_reload_timer_timeout() -> void:
	ready_to_fire = true
