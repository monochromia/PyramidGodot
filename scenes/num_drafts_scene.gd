extends CenterContainer

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
	


func start_run(num_drafts: int):
	var new_scene = load("res://scenes/card_flip_scene_head.tscn").instantiate()
	new_scene.selected_packs = selected_packs
	new_scene.num_drafts = num_drafts
	var packed_scene = PackedScene.new()
	packed_scene.pack(new_scene)
	get_tree().change_scene_to_packed(packed_scene)
	


func on_one_game_select(event: InputEvent):
	if (event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT):
		start_run(1)
	

func on_three_game_select(event: InputEvent):
	if (event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT):
		start_run(3)
	

func on_five_game_select(event: InputEvent):
	if (event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT):
		start_run(5)
	

func adjust_background_size():
	var window = get_window()
	$Background.set_custom_minimum_size(Vector2(window.size.x, window.size.y))
