extends CenterContainer


signal select_num_drafts(selected_packs: Array[PackData])

@export var selected_packs: Array[PackData] = []
var music_volume: float = 0
var sfx_volume: float = 0

const SAVE_PATH = "user://settings.cfg"


# Called when the node enters the scene tree for the first time.
func _ready():
	print("num drafts scene ready")
	var config := ConfigFile.new()
	
	config.load(SAVE_PATH)
	
	if config.get_value("settings", "music_volume"):
		music_volume = config.get_value("settings", "music_volume")
		
	if config.get_value("settings", "sfx_volume"):
		sfx_volume = config.get_value("settings", "sfx_volume")

	$BGM.volume_db = music_volume
	$BGM.play()
	
	adjust_background_size()
	get_tree().root.connect("size_changed", adjust_background_size)
	
	print("active packs:")
	
	for pack in selected_packs:
		print(pack.name)
	

func adjust_background_size():
	var window = get_window()
	$Background.set_custom_minimum_size(Vector2(window.size.x, window.size.y))
