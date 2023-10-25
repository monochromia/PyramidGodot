extends Node2D

var music_volume: float = 0
var sfx_volume: float = 0
var fullscreen: bool = false
var mod_folder_path : String = ""
var config := ConfigFile.new()

const SAVE_PATH = "user://settings.cfg"

# Called when the node enters the scene tree for the first time.
func _ready():	
	config.load(SAVE_PATH)
	
	if config.get_value("settings", "music_volume"):
		music_volume = config.get_value("settings", "music_volume")
		
	if config.get_value("settings", "sfx_volume"):
		sfx_volume = config.get_value("settings", "sfx_volume")
		
	if config.get_value("settings", "fullscreen"):
		fullscreen = config.get_value("settings", "fullscreen")
	
	if config.get_value("settings", "mod_folder_path"):
		mod_folder_path = config.get_value("settings", "mod_folder_path")
		
	$MusicVolumeSlider.set_value_no_signal(2 * (music_volume + 50))
	$SFXVolumeSlider.set_value_no_signal(2 * (sfx_volume + 50))
	$FullscreenToggle.set_pressed_no_signal(fullscreen)
	
	$Music.volume_db = music_volume
	$Music.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_save_button_pressed():
	config.load(SAVE_PATH)
	
	config.set_value("settings", "music_volume", music_volume)
	config.set_value("settings", "sfx_volume", sfx_volume)
	config.set_value("settings", "fullscreen", fullscreen)
	
	config.save(SAVE_PATH)
	
	_on_cancel_button_pressed()
	
func _on_cancel_button_pressed():
	get_tree().change_scene_to_file("res://scenes/Main Menu.tscn")
	
	
func _on_music_volume_slider_update(value: float):
	music_volume = 0 - (100 - value) / 2
	$Music.volume_db = music_volume
	
	
func _on_sfx_volume_slider_update(value: float):
	sfx_volume = 0 - (100 - value) / 2
	$SFXTestSound.volume_db = sfx_volume
	$SFXTestSound.play()

func _on_fullscreen_toggle_update(fullscreen_active: bool):
	fullscreen = fullscreen_active
	
	if fullscreen:
		get_window().set_mode(Window.MODE_FULLSCREEN)
	else:
		get_window().set_mode(Window.MODE_WINDOWED)
		
func _on_select_button_pressed():
	print("Current Mod Folder Path is " + mod_folder_path)
	$FileDialog.popup()

func _on_file_dialog_dir_selected(dir):
	mod_folder_path = dir
	config.set_value("settings", "mod_folder_path", mod_folder_path)
	print("Saved Mod Folder Path as " + dir)
	config.save(SAVE_PATH)
	
