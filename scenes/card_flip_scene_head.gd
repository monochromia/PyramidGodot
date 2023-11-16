extends Node2D

var music_volume: float = 0
var sfx_volume: float = 0

const SAVE_PATH = "user://settings.cfg"

const BACK_SOUND = preload("res://sounds/Menu_Sounds_V2_Minimalistic_BACKWARD.wav")
const ROLL_SOUND = preload("res://sounds/dice-roll.wav")

@export var selected_packs: Array[PackData] = []
@export var num_drafts: int

# Called when the node enters the scene tree for the first time.
func _ready():
	print("num drafts:")
	print(num_drafts)
	
	print("selected packs:")
	for pack in selected_packs:
		print(pack.title)
		
	var config := ConfigFile.new()
	
	config.load(SAVE_PATH)
	
	if config.get_value("settings", "music_volume"):
		music_volume = config.get_value("settings", "music_volume")
		
	if config.get_value("settings", "sfx_volume"):
		sfx_volume = config.get_value("settings", "sfx_volume")
		
	$BGM.volume_db = music_volume
	$SFX.volume_db = sfx_volume
	$BGM.play()


func adjust_background_size():
	var window = get_window()
	$Background.set_custom_minimum_size(Vector2(window.size.x, window.size.y))
	$Background.set_custom_maximum_size(Vector2(window.size.x, window.size.y))


func _on_options_button_click():
	get_tree().change_scene_to_file("res://scenes/Options Menu.tscn")
	

func _on_back_button_click():
	var new_scene = load("res://scenes/num_drafts_scene.tscn").instantiate()
	new_scene.selected_packs = selected_packs
	var packed_scene = PackedScene.new()
	packed_scene.pack(new_scene)
	
	# New sfx
	$SFX.stream = BACK_SOUND
	$SFX.play()
	
	get_tree().change_scene_to_packed(packed_scene)
	

func _on_exit_button_click():
	get_tree().quit()

func _on_roll_dice_button_pressed():
	# Generate a random number between 1 and 6
	var dice_roll = randi() % 6 + 1

	# Get the TextureRect node
	var texture_rect = get_node("Background/D6")

	# Load the appropriate texture based on the dice roll
	var texture_path = "sprites/ui/d" + str(dice_roll) + ".png"
	var new_texture = load(texture_path)

	# Update the texture of the TextureRect
	texture_rect.texture = new_texture
	
	# New sfx
	$SFX.stream = ROLL_SOUND
	$SFX.play()

	# Make the TextureRect visible
	texture_rect.visible = true
