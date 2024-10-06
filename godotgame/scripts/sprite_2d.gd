extends Sprite2D

func _ready() -> void:
	set_flip_v(true)

func _process(_delta: float) -> void:
	look_at(get_global_mouse_position())
	set_flip_v(cos(rotation) < 0)
