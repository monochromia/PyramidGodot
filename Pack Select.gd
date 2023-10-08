extends Node

var fullscreen: bool = false
var music_volume: float = 0
var sfx_volume: float = 0
var mod_folder_path : String = ""
var all_packs: Array[PackData]

const SAVE_PATH = "user://settings.cfg"
const Slot = preload("res://pack_select/slot.tscn")
@onready var background = $Background
@onready var pack_select_data = $"MarginContainer/OuterGrid/Pack Select Data"

# Called when the node enters the scene tree for the first time.
func _ready():
	load_settings()
	get_tree().root.connect("size_changed", adjust_background_size)



func load_settings():
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
	
	adjust_background_size()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func adjust_background_size():
	var window = get_window()
	$Background.set_custom_minimum_size(Vector2(window.size.x, window.size.y))

func _on_options_button_pressed():
	get_tree().change_scene_to_file("res://Options Menu.tscn")


func _on_end_run_button_pressed():
	get_tree().change_scene_to_file("res://Main Menu.tscn")


func _on_prev_page_button_pressed():
	pack_select_data.prev_page()


func _on_next_page_button_pressed():
	pack_select_data.next_page()
