extends Control

func returns():
	get_tree().paused = false
	queue_free()
