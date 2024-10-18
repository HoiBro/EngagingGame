extends AudioStreamPlayer

signal shotgun_fired

func _ready() -> void:
	connect("shotgun_fired",shotgun)

func shotgun():
	play()
