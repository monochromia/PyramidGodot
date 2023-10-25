extends Node2D

var fullscreen: bool = false
var music_volume: float = 0
var sfx_volume: float = 0

const SAVE_PATH = "user://settings.cfg"

# Called when the node enters the scene tree for the first time.
func _ready():
	var config := ConfigFile.new()
	
	config.load(SAVE_PATH)
	
	if config.get_value("settings", "music_volume"):
		music_volume = config.get_value("settings", "music_volume")
		
	if config.get_value("settings", "sfx_volume"):
		sfx_volume = config.get_value("settings", "sfx_volume")
		
	if config.get_value("settings", "fullscreen"):
		fullscreen = config.get_value("settings", "fullscreen")
	
	if fullscreen:
		get_window().set_mode(Window.MODE_FULLSCREEN)
	else:
		get_window().set_mode(Window.MODE_WINDOWED)
		
	$BGM.volume_db = music_volume
	$BGM.play()
	
	adjust_background_size()
	get_tree().root.connect("size_changed", adjust_background_size)


func adjust_background_size():
	var window = get_window()
	$Background.set_custom_minimum_size(Vector2(window.size.x, window.size.y))
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://scenes/Pack Select.tscn")


func _on_options_button_pressed():
	get_tree().change_scene_to_file("res://scenes/Options Menu.tscn")


func _on_quit_button_pressed():
	get_tree().quit()
