extends Node2D

@export var reload_time = 1.8
@export var recoil = 1000
@export var ready_to_fire: bool = true
@export var raycast = Vector2(50, 100)

@onready var player: CharacterBody2D = $".."

var SPACE_STATE = {
	"position": Vector2(0, 0),
	"collider": Object
}

func _ready() -> void:
	position = Vector2(25, 10)
	scale = Vector2(1.3, 1.3)

func _input(event) -> void:
	if event.is_action_pressed(&"fire shotgun") && ready_to_fire:
		player.velocity += -get_local_mouse_position().normalized() * recoil
		get_tree().create_timer(reload_time, false).timeout.connect(_on_reload_timer_timeout)
		$AudioStreamPlayer.play()
		SPACE_STATE = get_world_2d().direct_space_state.intersect_ray(PhysicsRayQueryParameters2D.create(-get_local_mouse_position().normalized()*(Vector2(0, 0), raycast)))
		ready_to_fire = false

func _on_reload_timer_timeout() -> void:
	ready_to_fire = true
