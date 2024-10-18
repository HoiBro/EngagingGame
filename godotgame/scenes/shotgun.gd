extends Node2D

signal shotgun_fired

@export var reload_time = 1.8
@export var recoil = 1000
@export var ready_to_fire = true

@onready var reloadTimer = $reloadTimer

func _input(event):
	if event.is_action_pressed(&"fire shotgun"):
		if ready_to_fire:
			emit_signal("shotgun_fired",get_local_mouse_position(),recoil)
			reloadTimer.start(reload_time)
			ready_to_fire = false

func _on_reload_timer_timeout() -> void:
	ready_to_fire = true
