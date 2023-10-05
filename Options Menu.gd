extends Node2D

var volume: float = 0
var fullscreen: bool = false

const SAVE_PATH = "user://settings.ini"


# Called when the node enters the scene tree for the first time.
func _ready():
	var config := ConfigFile.new()
	
	config.load(SAVE_PATH)
	
	if config.get_value("settings", "volume"):
		volume = config.get_value("settings", "volume")
		
	if  config.get_value("settings", "fullscreen"):
		fullscreen = config.get_value("settings", "fullscreen")
	
	$VolumeSlider.set_value_no_signal(2 * (volume + 50))
	$FullscreenToggle.set_pressed_no_signal(fullscreen)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_save_button_pressed():
	var config := ConfigFile.new()
	
	config.load(SAVE_PATH)
	
	config.set_value("settings", "volume", volume)
	config.set_value("settings", "fullscreen", fullscreen)
	
	config.save(SAVE_PATH)
	
	_on_cancel_button_pressed()
	
	
func _on_cancel_button_pressed():
	get_tree().change_scene_to_file("res://Main Menu.tscn")
	
	
func _on_volume_slider_update(value: float):
	volume = 0 - (100 - value) / 2
	$AudioStreamPlayer.volume_db = volume
	$AudioStreamPlayer.play()


func _on_fullscreen_toggle_update(fullscreen_active: bool):
	fullscreen = fullscreen_active
	
	if fullscreen:
		get_window().set_mode(Window.MODE_FULLSCREEN)
	else:
		get_window().set_mode(Window.MODE_WINDOWED)
