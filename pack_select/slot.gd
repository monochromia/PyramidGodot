extends PanelContainer

signal slot_clicked(index: int, button: int)

@onready var pack_image: TextureRect = $"Pack Image"

func load_image_into_texture(image_path):
	var im = Image.new()
	im = Image.load_from_file(image_path)  # Create a new Image instance
	
	#TODO: Set pack size dynamically based on number of rows/columns decided by screen size or user settings? idk.
	# This solution works but messes up resolution something fierce
	im.resize(300,450)
	
	if im != Image.new():  # Check if the image loaded successfully
		var texture = ImageTexture.new()  # Create a new ImageTexture instance
		
		texture = ImageTexture.create_from_image(im)  # Assign the image to the texture
		texture.set_size_override(Vector2i(240,360))
		return texture  # Return the texture
	else:
		print("Failed to load image: ", image_path)
		return null

func set_slot_data(slot_data: SlotData) -> void:
	var pack_data = slot_data.pack_data
	pack_image.texture = load_image_into_texture(pack_data.texture_path)
	tooltip_text = "%s\n%s\n(Left-Click to Add Copy to Run)\n(Right-Click to Remove Copy from Run)" % [pack_data.title, pack_data.genre1]
	

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton \
			and (event.button_index == MOUSE_BUTTON_LEFT \
			or event.button_index == MOUSE_BUTTON_RIGHT) \
			and event.is_pressed():
		slot_clicked.emit(get_index(), event.button_index)
