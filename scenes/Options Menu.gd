extends Node2D

var music_volume: float = 0
var sfx_volume: float = 0
var fullscreen: bool = false
var mod_folder_path : String = ""
var config := ConfigFile.new()
@onready var music_volume_slider = $"Background/MusicLabel/MusicVolumeSlider"
@onready var sfx_volume_slider = $"Background/SFXLabel/SFXVolumeSlider"
@onready var fullscreen_toggle = $"Background/FullscreenToggle"
@onready var music_player = $"Background/MusicLabel/Music"
@onready var sfx_test_sound = $"Background/SFXLabel/SFXTestSound"
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
		
	music_volume_slider.set_value_no_signal(2 * (music_volume + 50))
	sfx_volume_slider.set_value_no_signal(2 * (sfx_volume + 50))
	fullscreen_toggle.set_pressed_no_signal(fullscreen)
	
	music_player.volume_db = music_volume
	music_player.play()
	
	adjust_background_size()
	get_tree().root.connect("size_changed", adjust_background_size)


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
	music_player.volume_db = music_volume
	
	
func _on_sfx_volume_slider_update(value: float):
	sfx_volume = 0 - (100 - value) / 2
	sfx_test_sound.volume_db = sfx_volume
	sfx_test_sound.play()

func _on_fullscreen_toggle_update(fullscreen_active: bool):
	fullscreen = fullscreen_active
	
	if fullscreen:
		get_window().set_mode(Window.MODE_FULLSCREEN)
	else:
		get_window().set_mode(Window.MODE_WINDOWED)
		
func _on_select_button_pressed():
	print("Current Mod Folder Path is " + mod_folder_path)
	$"Options Menu Background/SelectButton/FileDialog".popup()

func _on_file_dialog_dir_selected(dir):
	mod_folder_path = dir
	config.set_value("settings", "mod_folder_path", mod_folder_path)
	print("Saved Mod Folder Path as " + dir)
	config.save(SAVE_PATH)
	
	

func adjust_background_size():
	var window = get_window()
	$Background.set_custom_minimum_size(Vector2(window.size.x, window.size.y))
	$BackgroundImage.set_custom_minimum_size(Vector2(window.size.x, window.size.y))
