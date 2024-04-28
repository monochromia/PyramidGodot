extends Node2D

var music_volume: float = 0
var sfx_volume: float = 0

const SAVE_PATH = "user://settings.cfg"

var draft_generator = preload("res://draft/draft_gen.gd").new()
var deck_generator = preload("res://deck/deck.tscn")

const BACK_SOUND = preload("res://sounds/Menu_Sounds_V2_Minimalistic_BACKWARD.wav")
const ROLL_SOUND = preload("res://sounds/dice-roll.wav")

@onready var card_row = $Background/MarginContainer/GridContainer/CardRow

@export var selected_packs: Array[PackData] = []
@export var num_drafts: int

# Called when the node enters the scene tree for the first time.
func _ready():
	print("num drafts:")
	print(num_drafts)
	
	card_row.columns = num_drafts
	
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
	
	generate_draft()


func generate_draft():
	# clear any old draft items
	for child in card_row.get_children():
		child.queue_free()
		
	# Ensure the wordbank is loaded
	if draft_generator.is_wordbank_ready():
		var random_adjective = draft_generator.get_random_adjective()
		var random_noun = draft_generator.get_random_noun()
		$Background/MarginContainer/GridContainer/TopRow/RunTitle.clear()
		$Background/MarginContainer/GridContainer/TopRow/RunTitle.text = "[center]{a} Pyramid of {n}[/center]".format({"a": random_adjective, "n": random_noun})
	else:
		print("Wordbank is still loading...")
	
	# shuffle packs for random selection	
	selected_packs.shuffle()
	
	var active_packs = []
	
	for i in range(num_drafts):
		active_packs.push_back(selected_packs.pick_random())
	
	var index = 0
	for pack_data in active_packs:
		generate_deck(pack_data, index)
		index = index + 1


func generate_deck(pack_data: PackData, index: int):
	var new_deck = deck_generator.instantiate()
	new_deck.set_pack_data(pack_data)
	new_deck.adjust_sizing(num_drafts)
	position_deck(new_deck, index)
	card_row.add_child(new_deck)


func adjust_background_size():
	var window = get_window()
	$Background.set_custom_minimum_size(Vector2(window.size.x, window.size.y))
	$Background.set_custom_maximum_size(Vector2(window.size.x, window.size.y))


func position_deck(deck: Deck, index: int):
	var container_width = card_row.size.x
	var deck_width = deck.WIDTH * deck.SCALE

	# Calculate the spacing and position
	var total_deck_width = num_drafts * deck_width
	var spacing = ((container_width - total_deck_width) / (num_drafts + 1)) - 40
	var offset_diff = 2
	
	if num_drafts == 3:
		offset_diff = 4
	elif num_drafts == 5:
		offset_diff = 6
		
	var x_position = (deck_width + spacing) * index + (card_row.size.x / offset_diff)

	# Center the deck vertically within the GridContainer
	var y_position = 120 + (card_row.size.y - deck.HEIGHT * deck.SCALE) / 2

	# Set the deck's position
	deck.position = Vector2(x_position, y_position)


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
	# Randomize the seed for randomization
	randomize()
	
	# Generate a random number between 1 and 6
	var dice_roll = randi() % 6 + 1

	# Get the TextureRect node
	var texture_rect = get_node("Background/MarginContainer/GridContainer/BottomRow/DiceBox/D6")

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
