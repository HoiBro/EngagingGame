extends Node2D

signal shotgun_fired

@export var reload_time = 2

@onready var reloadTimer = $reloadTimer

func _input(event):
	if event.is_action_pressed(&"fire shotgun"):
		if reloadTimer:
			emit_signal("shotgun_fired",get_local_mouse_position())
			reloadTimer.start(reload_time)
