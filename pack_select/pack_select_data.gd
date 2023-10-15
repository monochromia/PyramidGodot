extends PanelContainer

class_name PackSelectData

signal pack_clicked(pack: PackData, left_click: bool)

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
	var packs_dir = DirAccess.open(mod_folder_path + "/PACKS")
	
	if packs_dir:
		packs_dir.list_dir_begin()
		var cur_pack_dir = mod_folder_path + "/PACKS/"
		var next = packs_dir.get_next()
		while next != "":
			var files = DirAccess.open(cur_pack_dir + "/" +next).get_files()
			for file in files:
			# Check if the file is an image by checking its extension
				if (file.ends_with(".png") or file.ends_with(".jpg") or file.ends_with(".jpeg")) and file.begins_with("b1"):
					var new_pack = PackData.new()
					new_pack.name = next
					new_pack.texture_path = cur_pack_dir + "/" + next + "/" + file
	
					all_packs.push_back(
						new_pack
					)
			next = packs_dir.get_next()
#				file_name = cur_pack_dir.get_next()  # Get the next file name
#			cur_pack_dir = packs_dir.get_next()
#
#		packs_dir.list_dir_end()  # Finish reading the directory
		
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


func visible_packs() -> Array[PackData]:
	return all_packs.slice(starting_index, starting_index + page_size)


func populate_pack_select():
	var pack_data = visible_packs()
	
	for child in grid_container.get_children():
		child.queue_free()
		
	for pack_datum in pack_data:
		if pack_datum:
			var slot = Slot.instantiate()
			var slot_data = SlotData.new()
			slot_data.pack_data = pack_datum
			slot.slot_clicked.connect(on_slot_clicked)
			grid_container.add_child(slot)
			slot.set_slot_data(slot_data)
	
	
func load_settings():
	var config := ConfigFile.new()
	
	config.load(SAVE_PATH)
	
	if config.get_value("settings", "mod_folder_path"):
		mod_folder_path = config.get_value("settings", "mod_folder_path")

func on_slot_clicked(index: int, button: int) -> void:
	var current_packs = visible_packs()
	var clicked_pack = current_packs[index]
	var left_click = true
	
	if button == MOUSE_BUTTON_RIGHT:
		left_click = false
		
	pack_clicked.emit(clicked_pack, left_click)
	
