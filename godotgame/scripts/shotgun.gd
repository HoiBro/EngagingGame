extends Node2D

@export var reload_time = 1.8
@export var recoil = 1000
@export var ready_to_fire: bool = true

@onready var player = $".."

func _ready() -> void:
	position = Vector2(25, 10)
	scale = Vector2(1.3, 1.3)

func _input(event):
	if event.is_action_pressed(&"fire shotgun") && ready_to_fire:
		player.velocity += -get_local_mouse_position().normalized() * recoil
		get_tree().create_timer(reload_time, false).timeout.connect(_on_reload_timer_timeout)
		$AudioStreamPlayer.play()
		ready_to_fire = false

func _on_reload_timer_timeout():
	ready_to_fire = true
