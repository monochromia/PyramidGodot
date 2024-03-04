extends PanelContainer

class_name Deck

var backgrounds: Array[String] = []
var primaries: Array[String] = []
var secondaries: Array[String] = []
var curses: Array[String] = []

@onready var primary = $BoxContainer3/BoxContainer/primary
@onready var secondary = $BoxContainer3/BoxContainer/secondary
@onready var curse = $BoxContainer3/BoxContainer2/curse

func list_files_in_directory(path):
	var files = []
	var dir = DirAccess.open(str(path))
	var error = DirAccess.get_open_error()
	dir.list_dir_begin()
	

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with(".") and (file.ends_with(".png") or file.ends_with(".jpg")):
			files.append(file)

	dir.list_dir_end()

	return files


func index_images(image_paths: PackedStringArray):
	for path in image_paths:
		if path.begins_with("b"):
			backgrounds.append(path)
		elif path.begins_with("c"):
			curses.append(path)
		elif path.begins_with("p"):
			primaries.append(path)
		elif path.begins_with("s"):
			secondaries.append(path)


func set_pack_data(pack_data: PackData):
	var texture_dir_parts = pack_data.texture_path.split("/")
	texture_dir_parts.remove_at(texture_dir_parts.size() - 1)
	var texture_dir = ""
	
	for part in texture_dir_parts:
		if part != "":
			texture_dir += "/"
			texture_dir += part
	texture_dir = texture_dir.substr(1)
	var image_paths = list_files_in_directory(texture_dir)
	
	index_images(image_paths)
	
	print(backgrounds)
	print(primaries)
	print(secondaries)
	print(curses)
	

func adjust_sizing(num_instances: int):
	print(num_instances)
