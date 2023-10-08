extends PanelContainer

class_name PackSelectData

@export var slot_data: Array[SlotData]

var mod_folder_path : String = ""
var all_packs: Array[PackData]
var starting_index: int = 0
var page_size: int = 12

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
				new_pack.texture_path = mod_folder_path + "/Card Backs App/" + file_name
				
				all_packs.push_back(
					new_pack
				)
			
			file_name = card_backs_dir.get_next()  # Get the next file name
		
		card_backs_dir.list_dir_end()  # Finish reading the directory
		
		all_packs.sort_custom(sort_packs)
		
		populate_pack_select()
	else:
		print("Could not open directory")


func sort_packs(a: PackData, b: PackData):
	if a.name < b.name:
		return true
	return false


func next_page():
	starting_index = starting_index + page_size % all_packs.size()

	populate_pack_select()


func prev_page():
	starting_index -= page_size
	
	if starting_index < 0:
		starting_index = all_packs.size() - page_size
		
	populate_pack_select()


func populate_pack_select():
	var pack_data = all_packs.slice(starting_index, starting_index + page_size)
	
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
