extends Button

var main
var level_select

func button_pressed():
	main.paused = false
	level_select.visible = false
	load_tileset()

func load_tileset():
	pass
