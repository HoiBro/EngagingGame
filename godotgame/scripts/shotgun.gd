extends Node2D

@export var reload_time = 1.8
@export var recoil = 1000
@export var ready_to_fire: bool = true

@onready var player = $".."

func _input(event):
	if event.is_action_pressed(&"fire shotgun") && ready_to_fire:
		player.velocity += -get_local_mouse_position().normalized() * recoil
		$AudioStreamPlayer.play()
		$reloadTimer.start(reload_time)
		ready_to_fire = false

func _on_reload_timer_timeout() -> void:
	ready_to_fire = true
