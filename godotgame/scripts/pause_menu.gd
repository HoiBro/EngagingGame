extends Node

@onready var menu = $Window

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		get_tree().paused = !get_tree().paused
		if menu.visible:
			menu.hide()
		else:
			menu.show()

func _process(_delta: float) -> void:
	pass
