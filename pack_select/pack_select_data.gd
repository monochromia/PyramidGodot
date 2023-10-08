extends PanelContainer

class_name PackSelectData

@export var slot_data: Array[SlotData]

var mod_folder_path : String = ""
var all_packs: Array[PackData]

const SAVE_PATH = "user://settings.cfg"
const Slot = preload("res://pack_select/slot.tscn")
@onready var pack_select_data = $"."
@onready var grid_container = $MarginContainer/GridContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	load_settings()
	
	if mod_folder_path:
		load_cards()
	else:
		# Todo: Tell the user to update the mods path
		pass


func load_image_into_texture(image_path):
	var image = Image.new()  # Create a new Image instance
	var error = image.load(image_path)  # Load the image file
	
	if error == OK:  # Check if the image loaded successfully
		var texture = ImageTexture.new()  # Create a new ImageTexture instance
		texture.create_from_image(image)  # Assign the image to the texture
		return texture  # Return the texture
	else:
		print("Failed to load image: ", image_path)
		return null
		
		


func load_cards():
	var card_backs_dir = DirAccess.open(mod_folder_path + "/Card Backs App")
	
	if card_backs_dir:
		card_backs_dir.list_dir_begin()
		
		var file_name = card_backs_dir.get_next()
		while file_name != "":
			if card_backs_dir.current_is_dir(): # if it's a directory
				file_name = card_backs_dir.get_next()
				continue
				
			# Check if the file is an image by checking its extension
			if file_name.ends_with(".png") or file_name.ends_with(".jpg") or file_name.ends_with(".jpeg"):
				var new_pack = PackData.new()
				new_pack.name = file_name.split('.')[0]
				new_pack.texture = load_image_into_texture(mod_folder_path + "/Card Backs App/" + file_name)
				
				if new_pack.texture:
					all_packs.push_back(
						new_pack
					)
			
			file_name = card_backs_dir.get_next()  # Get the next file name
		
		card_backs_dir.list_dir_end()  # Finish reading the directory
		
		populate_pack_select(all_packs.slice(0, 12))
	else:
		print("Could not open directory")
		
		
	

func populate_pack_select(pack_data: Array[PackData]):
	for child in grid_container.get_children():
		child.queue_free()
		
	for pack_datum in pack_data:
		if pack_datum:
			var slot = Slot.instantiate()
			var slot_data = SlotData.new()
			slot_data.pack_data = pack_datum
			grid_container.add_child(slot)
			slot.set_slot_data(slot_data)
	
	
func load_settings():
	var config := ConfigFile.new()
	
	config.load(SAVE_PATH)
	
	if config.get_value("settings", "mod_folder_path"):
		mod_folder_path = config.get_value("settings", "mod_folder_path")
