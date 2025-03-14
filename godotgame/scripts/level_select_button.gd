extends Button

var PauseWindow
var LevelSelect
@onready var main = $"../../../.."

func _on_pressed() -> void:
	PauseWindow.visible = false
	LevelSelect.visible = true
	main.paused = true
	print("button pressed")
