extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_flip_v(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	look_at(get_global_mouse_position())
	set_flip_v(cos(rotation) < 0)
