extends AudioStreamPlayer

signal shotgun_fired

@onready var shotgun = get_parent()

func _ready() -> void:
	shotgun.connect("shotgun_fired",play_SFX)
	print(shotgun)

func play_SFX(_POS):
	play()
	print("shotgun SFX")
