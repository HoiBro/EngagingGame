extends AudioStreamPlayer

signal shotgun_fired

@onready var shotgun = get_parent()

func _ready() -> void:
	shotgun.connect("shotgun_fired",play_SFX)

func play_SFX(_POS,_RECOIL):
	play()
