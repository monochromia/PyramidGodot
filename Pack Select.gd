extends Node

var fullscreen: bool = false
var music_volume: float = 0
var sfx_volume: float = 0
var mod_folder_path : String = ""

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
	
	if config.get_value("settings", "mod_folder_path"):
		mod_folder_path = config.get_value("settings", "mod_folder_path")
		
	$BGM.volume_db = music_volume
	$BGM.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_options_button_pressed():
	get_tree().change_scene_to_file("res://Options Menu.tscn")


func _on_end_run_button_pressed():
	get_tree().change_scene_to_file("res://Main Menu.tscn")
