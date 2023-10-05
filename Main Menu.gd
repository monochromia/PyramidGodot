extends Node2D

var fullscreen: bool = false

const SAVE_PATH = "user://settings.ini"

# Called when the node enters the scene tree for the first time.
func _ready():
	var config := ConfigFile.new()
	
	config.load(SAVE_PATH)
		
	if  config.get_value("settings", "fullscreen"):
		fullscreen = config.get_value("settings", "fullscreen")
	
	if fullscreen:
		get_window().set_mode(Window.MODE_FULLSCREEN)
	else:
		get_window().set_mode(Window.MODE_WINDOWED)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://Pack Select.tscn")


func _on_options_button_pressed():
	get_tree().change_scene_to_file("res://Options Menu.tscn")


func _on_quit_button_pressed():
	get_tree().quit()
