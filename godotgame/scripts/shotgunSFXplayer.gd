extends AudioStreamPlayer

func _input(event):
	if event.is_action_pressed(&"fire shotgun"):
		play()
