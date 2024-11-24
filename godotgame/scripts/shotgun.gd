extends Node2D

@export var reload_time = 1.8
@export var recoil = 1000
@export var ready_to_fire: bool = true
@export var raycast = 100
@export var result = {}

@onready var player: CharacterBody2D = $".."
@onready var shotgun_model: Sprite2D = $"../PlayerSprite/Sprite2D/Shotgun"

var MPOS: Vector2 = Vector2(0, 0)
signal raycast_result

func _ready() -> void:
	position = Vector2(25, 10)
	scale = Vector2(1.3, 1.3)

func _input(event) -> void:
	if event.is_action_pressed(&"fire shotgun") && ready_to_fire:
		MPOS = -get_local_mouse_position().normalized()
		player.velocity += MPOS * recoil
		
		get_tree().create_timer(reload_time, false).timeout.connect(_on_reload_timer_timeout)
		
		$AudioStreamPlayer.play()
		
		var query = PhysicsRayQueryParameters2D.create(shotgun_model.position + player.position, shotgun_model.position + player.position + MPOS * raycast, 4294967295, [player])
		var cast = get_world_2d().direct_space_state.intersect_ray(query)
		if cast:
			print(cast)
			result.collider = cast.collider
			raycast_result.emit()
		
		ready_to_fire = false

func _on_reload_timer_timeout() -> void:
	ready_to_fire = true
