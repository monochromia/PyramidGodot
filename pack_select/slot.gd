extends PanelContainer

@onready var pack_image: TextureRect = $"Pack Image"

func load_image_into_texture(image_path):
	var im = Image.new()
	im = Image.load_from_file(image_path)  # Create a new Image instance
	
	#TODO: Set pack size dynamically based on number of rows/columns decided by screen size or user settings? idk.
	# This solution works but messes up resolution something fierce
	im.resize(150,225)
	
	if im != Image.new():  # Check if the image loaded successfully
		var texture = ImageTexture.new()  # Create a new ImageTexture instance
		
		texture = ImageTexture.create_from_image(im)  # Assign the image to the texture
		texture.set_size_override(Vector2i(130, 195))
		return texture  # Return the texture
	else:
		print("Failed to load image: ", image_path)
		return null

func set_slot_data(slot_data: SlotData) -> void:
	var pack_data = slot_data.pack_data
	pack_image.texture = load_image_into_texture(pack_data.texture_path)
	tooltip_text = "%s\n(Left-Click to Add Copy to Run)\n(Right-Click to Remove Copy from Run)" % [pack_data.name]
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
